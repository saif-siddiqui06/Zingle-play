enum AppPlan {
  free,
  basic,
  premium;

  bool get isPaid => this == basic || this == premium;
  bool get isPremium => this == premium;
  bool get canUseTransport => isPaid;
  bool get canUseLibraryPowerTools => isPaid;
  bool get canUsePremiumTools => isPremium;

  String get label => switch (this) {
        AppPlan.free => 'Free',
        AppPlan.basic => 'Basic',
        AppPlan.premium => 'Premium',
      };

  String get productId => switch (this) {
        AppPlan.free => 'free',
        AppPlan.basic => 'basic_lifetime',
        AppPlan.premium => 'premium_lifetime',
      };

  static AppPlan fromName(String? value) {
    return AppPlan.values.firstWhere(
      (plan) => plan.name == value,
      orElse: () => AppPlan.free,
    );
  }
}
