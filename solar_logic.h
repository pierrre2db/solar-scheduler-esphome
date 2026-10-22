#pragma once
// Logique de planification v3 : pure (sans dépendance ESPHome), testable sur PC.
// Les heures fixes sont reconstruites en heure LOCALE (mktime, tm_isdst = -1),
// ce qui gère le changement d'heure été/hiver.
#include <stdint.h>
#include <time.h>

namespace solar {

enum Mode { FIXE = 0, SUNRISE = 1, SUNSET = 2, MANUEL = 3 };

struct Params {
  int mode;
  int on_min;      // heure fixe ON, minutes depuis minuit
  int off_min;     // heure fixe OFF, minutes depuis minuit
  int off_sr_s;    // offset lever, secondes
  int off_ss_s;    // offset coucher, secondes
};

struct Result {
  bool on;         // état voulu à l'instant `now`
  bool has_next;   // un prochain événement existe
  time_t next;     // instant du prochain événement
  bool next_on;    // le prochain événement est un ON
};

// Instant local « minutes » du jour local de `ref`, décalé de `day_shift` jours.
inline time_t fixed_at(time_t ref, int minutes, int day_shift) {
  struct tm lt;
  localtime_r(&ref, &lt);
  lt.tm_hour = minutes / 60;
  lt.tm_min = minutes % 60;
  lt.tm_sec = 0;
  lt.tm_mday += day_shift;
  lt.tm_isdst = -1;
  return mktime(&lt);
}

// sunrise(day_ref, &t) / sunset(day_ref, &t) : renvoient true et remplissent t (instant de
// l'événement du jour contenant day_ref) s'il existe.
template <typename SR, typename SS>
Result evaluate(time_t now, const Params &p, SR sunrise, SS sunset) {
  time_t last_on = 0, last_off = 0, next = 0;
  bool next_on = false;
  auto consider = [&](time_t e, bool is_on) {
    if (e <= now) {
      time_t &last = is_on ? last_on : last_off;
      if (e > last) last = e;
    } else if (next == 0 || e < next) {
      next = e;
      next_on = is_on;
    }
  };
  for (int k = -2; k <= 2; k++) {
    time_t noon = fixed_at(now, 12 * 60, k);
    time_t t = 0;
    if (p.mode == FIXE) {
      consider(fixed_at(now, p.on_min, k), true);
      consider(fixed_at(now, p.off_min, k), false);
    } else if (p.mode == SUNRISE) {
      consider(fixed_at(now, p.on_min, k), true);
      if (sunrise(noon, &t)) consider(t + p.off_sr_s, false);
    } else if (p.mode == SUNSET) {
      if (sunset(noon, &t)) consider(t + p.off_ss_s, true);
      consider(fixed_at(now, p.off_min, k), false);
    }
  }
  Result r;
  r.on = last_on > last_off;
  r.has_next = next != 0;
  r.next = next;
  r.next_on = next_on;
  return r;
}

// Durée de sommeil (secondes) avant le prochain réveil, deux réveils par événement :
// si l'événement est loin, on se réveille un peu avant (marge = 10 % + marge_min) pour
// recaler l'heure par SNTP ; sinon on dort jusqu'à l'événement (+ garde de 5 s).
// Borné par periode_max_s (réveil périodique de configuration).
inline uint32_t sleep_seconds(time_t now, const Result &r, uint32_t marge_min_s,
                              uint32_t periode_max_s) {
  uint32_t s = periode_max_s;
  if (r.has_next && r.next > now) {
    uint32_t d = (uint32_t)(r.next - now);
    uint32_t marge = marge_min_s + d / 10;
    s = (d > 2 * marge) ? d - marge : d + 5;
  }
  if (s > periode_max_s) s = periode_max_s;
  if (s < 5) s = 5;
  return s;
}

}  // namespace solar
