/*
*Ella Muro
*8 June 2026
*Round Eligibility Logic
*/

class RoundEligibilityService {

  //Fields of the class
  final int totalRounds;
  final int totalPrepicks;

  //Constructor
  const RoundEligibilityService({
    this.totalRounds = 9,
    this.totalPrepicks = 2,
  });

  //True/false list for rounds (index 0 = Round 1)
  List<bool> computeRoundEligibility(int weeksAllowed) {
    return List.generate(
      totalRounds,
      (i) => (i + 1) <= weeksAllowed,
    );
  }

  //True/false list for prepicks (index 0 = Prepick 1)
  List<bool> computePrepickEligibility(int prepicksAllowed) {
    return List.generate(
      totalPrepicks,
      (i) => (i + 1) <= prepicksAllowed,
    );
  }
}