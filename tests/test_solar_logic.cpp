// Test hôte de solar_logic.h. Compiler : g++ -std=c++17 -I. tests/test_solar_logic.cpp -o /tmp/t && TZ=Europe/Brussels /tmp/t
#include <cstdio>
#include <cstdlib>
#include "solar_logic.h"

static int fails = 0;
#define CHECK(cond, msg) do { if (!(cond)) { printf("ECHEC: %s (ligne %d)\n", msg, __LINE__); fails++; } } while (0)

static time_t at(int y, int mo, int d, int h, int mi) {
  struct tm t = {}; t.tm_year = y - 1900; t.tm_mon = mo - 1; t.tm_mday = d; t.tm_hour = h; t.tm_min = mi; t.tm_isdst = -1;
  return mktime(&t);
}
// lever fixe 07:00 local, coucher fixe 19:00 local (simulé)
static bool sr(time_t noon, time_t *o) { *o = solar::fixed_at(noon, 7 * 60, 0); return true; }
static bool ss(time_t noon, time_t *o) { *o = solar::fixed_at(noon, 19 * 60, 0); return true; }
static bool none(time_t, time_t *) { return false; }

int main() {
  setenv("TZ", "Europe/Brussels", 1); tzset();
  using namespace solar;
  Params f{FIXE, 8 * 60, 18 * 60, 0, 0};
  auto r = evaluate(at(2026, 10, 22, 9, 0), f, sr, ss);
  CHECK(r.on, "fixe: 09:00 doit etre ON");
  CHECK(r.has_next && r.next == at(2026, 10, 22, 18, 0) && !r.next_on, "fixe: prochain = 18:00 OFF");
  r = evaluate(at(2026, 10, 22, 19, 0), f, sr, ss);
  CHECK(!r.on, "fixe: 19:00 doit etre OFF");
  CHECK(r.next == at(2026, 10, 23, 8, 0) && r.next_on, "fixe: prochain = demain 08:00 ON");
  Params w{FIXE, 22 * 60, 6 * 60, 0, 0};   // passe minuit
  r = evaluate(at(2026, 10, 22, 23, 0), w, sr, ss); CHECK(r.on, "minuit: 23:00 ON");
  r = evaluate(at(2026, 10, 23, 3, 0), w, sr, ss); CHECK(r.on, "minuit: 03:00 ON");
  r = evaluate(at(2026, 10, 23, 7, 0), w, sr, ss); CHECK(!r.on, "minuit: 07:00 OFF");
  Params eq{FIXE, 600, 600, 0, 0};
  r = evaluate(at(2026, 10, 22, 12, 0), eq, sr, ss); CHECK(!r.on, "ON==OFF: OFF");

  Params up{SUNRISE, 20 * 60, 0, 0, 0};     // ON 20:00, OFF au lever 07:00
  r = evaluate(at(2026, 10, 22, 21, 0), up, sr, ss); CHECK(r.on, "sunrise: 21:00 ON");
  r = evaluate(at(2026, 10, 23, 3, 0), up, sr, ss); CHECK(r.on, "sunrise: 03:00 ON");
  r = evaluate(at(2026, 10, 23, 10, 0), up, sr, ss); CHECK(!r.on, "sunrise: 10:00 OFF");
  Params dn{SUNSET, 0, 23 * 60, 0, 600};   // ON coucher+10min, OFF 23:00
  r = evaluate(at(2026, 10, 22, 19, 5), dn, sr, ss); CHECK(!r.on, "sunset: 19:05 pas encore");
  r = evaluate(at(2026, 10, 22, 19, 15), dn, sr, ss); CHECK(r.on, "sunset: 19:15 ON");
  r = evaluate(at(2026, 10, 22, 23, 30), dn, sr, ss); CHECK(!r.on, "sunset: 23:30 OFF");
  r = evaluate(at(2026, 10, 22, 12, 0), up, none, none); CHECK(r.on, "polaire sunrise: cote fixe ON");

  // Changement d'heure : 2026-03-29 (passage a 02:00 -> 03:00), 2026-10-25 (03:00 -> 02:00)
  Params d1{FIXE, 6 * 60, 22 * 60, 0, 0};
  r = evaluate(at(2026, 3, 29, 12, 0), d1, sr, ss);
  CHECK(r.on && r.next == at(2026, 3, 29, 22, 0), "DST printemps: 22:00 local");
  r = evaluate(at(2026, 10, 25, 12, 0), d1, sr, ss);
  CHECK(r.on && r.next == at(2026, 10, 25, 22, 0), "DST automne: 22:00 local");
  // heure fixe dans la plage manquante (02:30 le 29 mars) : ne doit pas planter et reste coherente
  Params gap{FIXE, 2 * 60 + 30, 22 * 60, 0, 0};
  r = evaluate(at(2026, 3, 29, 5, 0), gap, sr, ss); CHECK(r.on, "DST trou 02:30: ON a 05:00");

  // Durees de sommeil
  Result x{false, true, at(2026, 10, 22, 18, 0), false};
  time_t now = at(2026, 10, 22, 6, 0);        // 12 h avant
  uint32_t s = sleep_seconds(now, x, 300, 12 * 3600);
  CHECK(s == 12 * 3600 - (300 + 12 * 3600 / 10) , "sommeil long: reveil de marge");
  now = at(2026, 10, 22, 17, 55);             // 5 min avant
  s = sleep_seconds(now, x, 300, 12 * 3600); CHECK(s == 300 + 5, "sommeil court: jusqu'a l'evenement + 5 s");
  Result nn{false, false, 0, false};
  s = sleep_seconds(now, nn, 300, 12 * 3600); CHECK(s == 12 * 3600, "pas d'evenement: periode max");

  if (fails == 0) printf("Tous les tests passent.\n");
  return fails ? 1 : 0;
}
