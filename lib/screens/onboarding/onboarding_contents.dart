class OnboardingContents {
  final String title;
  final String image;
  final String desc;

  OnboardingContents({
    required this.title,
    required this.image,
    required this.desc,
  });
}

List<OnboardingContents> contents = [
  OnboardingContents(
    title: "Descubre Promociones",
    image: "assets/images/ti_image1.png",
    desc: "Encuentra las promociones que te resulten atractivas.",
  ),
  OnboardingContents(
    title: "Ubica tu Sucursal Favorita",
    image: "assets/images/ti_image2.png",
    desc: "Acercate a la sucursal más cercana.",
  ),
  OnboardingContents(
    title: "Aprovecha Descuentos Únicos",
    image: "assets/images/ti_image3.png",
    desc: "Presenta el código QR y disfruta de fabulosas promociones.",
  ),
];
