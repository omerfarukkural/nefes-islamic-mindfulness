import 'mizac_model.dart';

class MizacCalculator {
  static MizacType fromBirthSeason(DateTime birthDate) {
    final month = birthDate.month;
    if (month >= 3 && month <= 5) return MizacType.dem;
    if (month >= 6 && month <= 8) return MizacType.safra;
    if (month >= 9 && month <= 11) return MizacType.sevda;
    return MizacType.balgam;
  }

  static MizacType fromQuestionnaireAnswers(List<int> answers) {
    // Each answer maps to weights: [dem, safra, balgam, sevda]
    final weights = List.filled(4, 0);
    for (int i = 0; i < answers.length && i < _answerWeights.length; i++) {
      final answerIdx = answers[i].clamp(0, 3);
      final w = _answerWeights[i][answerIdx];
      for (int j = 0; j < 4; j++) {
        weights[j] += w[j];
      }
    }
    int maxIdx = 0;
    for (int i = 1; i < 4; i++) {
      if (weights[i] > weights[maxIdx]) maxIdx = i;
    }
    return MizacType.values[maxIdx];
  }

  // [dem, safra, balgam, sevda] weights for each answer of each question
  static const _answerWeights = [
    // Q1: Genel enerji seviyeniz?
    [[3,0,0,0], [0,3,0,0], [0,0,3,0], [0,0,0,3]],
    // Q2: Stres altında nasıl tepki verirsiniz?
    [[2,1,0,0], [0,3,0,0], [0,0,3,0], [0,0,0,3]],
    // Q3: Uyku düzeniniz?
    [[1,0,0,2], [0,1,0,2], [0,0,3,0], [2,0,0,1]],
    // Q4: İştah durumunuz?
    [[3,0,0,0], [0,3,0,0], [0,0,2,1], [0,0,0,3]],
    // Q5: Sosyal hayatınız?
    [[3,1,0,0], [1,2,0,0], [0,0,3,0], [0,0,0,3]],
    // Q6: Baskın duygunuz?
    [[3,0,0,0], [0,3,0,0], [0,0,3,0], [0,0,0,3]],
    // Q7: Fiziksel yapınız?
    [[2,1,0,0], [0,3,0,0], [0,0,3,0], [0,0,1,2]],
    // Q8: Sıcak/soğuğa toleransınız?
    [[2,0,1,0], [0,2,0,1], [1,0,2,0], [0,1,0,2]],
    // Q9: Karar verme biçiminiz?
    [[3,0,0,0], [0,3,0,0], [0,0,2,1], [0,0,0,3]],
    // Q10: En iyi hissettiren mevsim?
    [[3,0,0,0], [0,3,0,0], [0,0,3,0], [0,0,0,3]],
  ];
}
