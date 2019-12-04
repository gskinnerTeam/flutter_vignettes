import 'dart:math' as math;

enum BasketballGameQuarter {
  Q1,
  Q2,
  HALF_TIME,
  Q3,
  Q4,
  FINISHED,
}

class BasketballGameData {
  final BasketballGameQuarter quarter;
  final Duration time;

  final int homeTeamScore;
  final int awayTeamScore;

  final String homeTeamName;
  final String awayTeamName;

  final String homeTeamCity;
  final String awayTeamCity;

  final String homeTeamLogoPath;
  final String awayTeamLogoPath;

  BasketballGameData({
    this.quarter,
    this.time,
    this.homeTeamScore,
    this.awayTeamScore,
    this.homeTeamName,
    this.awayTeamName,
    this.homeTeamCity,
    this.awayTeamCity,
    this.homeTeamLogoPath,
    this.awayTeamLogoPath,
  });
}

class BasketballGameModel {
  final List<BasketballGameData> basketballGames;

  BasketballGameModel() :
    basketballGames = [
      BasketballGameData(
        quarter: BasketballGameQuarter.HALF_TIME,
        homeTeamScore: 63,
        awayTeamScore: 53,
        homeTeamName: 'Knights',
        awayTeamName: 'Flutters',
        homeTeamCity: 'New York',
        awayTeamCity: 'Edmonton',
        homeTeamLogoPath: 'assets/viking.png',
        awayTeamLogoPath: 'assets/f.png',
      ),
      BasketballGameData(
        quarter: BasketballGameQuarter.Q4,
        time: Duration(minutes: 7, seconds: 6),
        homeTeamScore: 115,
        awayTeamScore: 105,
        homeTeamName: 'Birds',
        awayTeamName: 'Stars',
        homeTeamCity: 'Birmingham',
        awayTeamCity: 'Seattle',
        homeTeamLogoPath: 'assets/flutter.png',
        awayTeamLogoPath: 'assets/badge.png',
      ),
      BasketballGameData(
        quarter: BasketballGameQuarter.Q4,
        time: Duration(minutes: 10, seconds: 28),
        homeTeamScore: 85,
        awayTeamScore: 88,
        homeTeamName: 'Dribblers',
        awayTeamName: 'Cannons',
        homeTeamCity: 'LA',
        awayTeamCity: 'Dallas',
        homeTeamLogoPath: 'assets/light.png',
        awayTeamLogoPath: 'assets/maroon.png',
      ),
      BasketballGameData(
        quarter: BasketballGameQuarter.FINISHED,
        homeTeamScore: 97,
        awayTeamScore: 109,
        homeTeamName: 'Knights',
        awayTeamName: 'Birds',
        homeTeamCity: 'New York',
        awayTeamCity: 'Birmingham',
        homeTeamLogoPath: 'assets/viking.png',
        awayTeamLogoPath: 'assets/flutter.png',
      ),
      BasketballGameData(
        quarter: BasketballGameQuarter.FINISHED,
        homeTeamScore: 112,
        awayTeamScore: 102,
        homeTeamName: 'Flutters',
        awayTeamName: 'Dribblers',
        homeTeamCity: 'Edmonton',
        awayTeamCity: 'LA',
        homeTeamLogoPath: 'assets/f.png',
        awayTeamLogoPath: 'assets/light.png',
      ),
      BasketballGameData(
        quarter: BasketballGameQuarter.HALF_TIME,
        homeTeamScore: 63,
        awayTeamScore: 53,
        homeTeamName: 'Knights',
        awayTeamName: 'Flutters',
        homeTeamCity: 'New York',
        awayTeamCity: 'Edmonton',
        homeTeamLogoPath: 'assets/viking.png',
        awayTeamLogoPath: 'assets/f.png',
      ),
      BasketballGameData(
        quarter: BasketballGameQuarter.Q4,
        time: Duration(minutes: 7, seconds: 6),
        homeTeamScore: 115,
        awayTeamScore: 105,
        homeTeamName: 'Birds',
        awayTeamName: 'Stars',
        homeTeamCity: 'Birmingham',
        awayTeamCity: 'Seattle',
        homeTeamLogoPath: 'assets/flutter.png',
        awayTeamLogoPath: 'assets/badge.png',
      ),
      BasketballGameData(
        quarter: BasketballGameQuarter.Q4,
        time: Duration(minutes: 10, seconds: 28),
        homeTeamScore: 85,
        awayTeamScore: 88,
        homeTeamName: 'Dribblers',
        awayTeamName: 'Cannons',
        homeTeamCity: 'LA',
        awayTeamCity: 'Dallas',
        homeTeamLogoPath: 'assets/light.png',
        awayTeamLogoPath: 'assets/maroon.png',
      ),
      BasketballGameData(
        quarter: BasketballGameQuarter.FINISHED,
        homeTeamScore: 97,
        awayTeamScore: 109,
        homeTeamName: 'Knights',
        awayTeamName: 'Birds',
        homeTeamCity: 'New York',
        awayTeamCity: 'Birmingham',
        homeTeamLogoPath: 'assets/viking.png',
        awayTeamLogoPath: 'assets/flutter.png',
      ),
      BasketballGameData(
        quarter: BasketballGameQuarter.FINISHED,
        homeTeamScore: 112,
        awayTeamScore: 102,
        homeTeamName: 'Flutters',
        awayTeamName: 'Dribblers',
        homeTeamCity: 'Edmonton',
        awayTeamCity: 'LA',
        homeTeamLogoPath: 'assets/f.png',
        awayTeamLogoPath: 'assets/light.png',
      ),
    ];

  BasketballGameModel.randomize() : basketballGames = <BasketballGameData>[] {
    final rng = math.Random();
    const List<String> teamCities = [
      'Seattle',
      'Edmonton',
      'Birmingham',
      'LA',
      'Dallas',
      'New York',
    ];
    const List<String> teamNames = [
      'Stars',
      'Flutters',
      'Birds',
      'Dribblers',
      'Cannons',
      'Knights',
    ];
    const List<String> logoPaths = [
      'assets/badge.png',
      'assets/f.png',
      'assets/flutter.png',
      'assets/light.png',
      'assets/maroon.png',
      'assets/viking.png',
    ];
    for (int i = 0; i < 10; ++i) {
      int homeTeam = rng.nextInt(6);
      int awayTeam;
      do {
        awayTeam = rng.nextInt(6);
      } while (awayTeam == homeTeam);

      basketballGames.add(
        BasketballGameData(
          quarter: BasketballGameQuarter.values[rng.nextInt(BasketballGameQuarter.values.length)],
          time: Duration(minutes: rng.nextInt(30), seconds: rng.nextInt(60)),
          homeTeamScore: rng.nextInt(160),
          awayTeamScore: rng.nextInt(160),
          homeTeamName: teamNames[homeTeam],
          awayTeamName: teamNames[awayTeam],
          homeTeamCity: teamCities[homeTeam],
          awayTeamCity: teamCities[awayTeam],
          homeTeamLogoPath: logoPaths[homeTeam],
          awayTeamLogoPath: logoPaths[awayTeam],
        ),
      );
    }
  }

  BasketballGameData getGameData(int index) {
    return basketballGames[index];
  }
}
