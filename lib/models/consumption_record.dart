class ConsumptionRecord {
  /// The time of the consumption.
  final DateTime consumptionTime;

  /// The name of the product.
  final String productName;

  /// The way of the consumption: oil, vape and smoke.
  final String consumptionMethod;

  final double thc;
  final double cbd;

  /// The amount of the product consumped.
  final double amount;

  /// The reason of the consumption: pain, sleep, hunger.
  final String whyConsumped;

  /// The effictiveness of the consumption.
  final int effictiveness;

  /// The type of the consumption product.
  final String type;

  /// The character of the consumption product.
  final String character;

  /// The category of the consumption product.
  final String category;

  final int symptomSeverityBeforeConsumption;

  final int symptomSeverityAfterConsumption;

  final String productImage;

  ConsumptionRecord(
    this.consumptionTime,
    this.productName,
    this.consumptionMethod,
    this.thc,
    this.cbd,
    this.amount,
    this.whyConsumped,
    this.effictiveness,
    this.type,
    this.character,
    this.category,
    this.symptomSeverityBeforeConsumption,
    this.symptomSeverityAfterConsumption,
    this.productImage,
  );
}
