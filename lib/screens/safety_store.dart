import 'package:basic/main.dart';
import 'package:flutter/material.dart';


class SafetyStoreScreen extends StatefulWidget {
  const SafetyStoreScreen({super.key});

  @override
  State<SafetyStoreScreen> createState() => _SafetyStoreScreenState();
}

class _SafetyStoreScreenState extends State<SafetyStoreScreen> {
  final _categories = const ['All', 'Pepper Sprays', 'Alarms', 'GPS', 'Keychains'];
  int _selectedCategory = 0;

  final List<_StoreItem> _items = const [
    _StoreItem(
      title: 'SHRI Pepper Spray',
      rating: 4.9,
      reviews: 120,
      price: 15.99,
      tag: 'BEST SELLER',
      imageStyle: _ImageStyle.pepperSpray,
      favorite: true,
    ),
    _StoreItem(
      title: '130dB Personal Siren',
      rating: 4.8,
      reviews: 85,
      price: 12.50,
      imageStyle: _ImageStyle.siren,
    ),
    _StoreItem(
      title: 'Smart GPS Keychain',
      rating: 5.0,
      reviews: 42,
      price: 29.99,
      imageStyle: _ImageStyle.keychain,
    ),
    _StoreItem(
      title: 'Elite Safety Kit',
      rating: 4.7,
      reviews: 214,
      price: 45.00,
      imageStyle: _ImageStyle.kit,
    ),
    _StoreItem(
      title: 'Stealth Pepper Spray',
      rating: 4.9,
      reviews: 151,
      price: 18.50,
      imageStyle: _ImageStyle.stealth,
    ),
    _StoreItem(
      title: 'Tactical Flashlight',
      rating: 4.8,
      reviews: 108,
      price: 22.00,
      imageStyle: _ImageStyle.flashlight,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: const TextScaler.linear(1.0),
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          bottom: false,
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    children: [
                      _TopBar(
                        cartCount: 2,
                        onCartTap: () {},
                        onBackTap: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(height: 12),
                      const _SearchBar(hint: 'Search safety gear...'),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 34,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _categories.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 10),
                          itemBuilder: (context, i) {
                            final selected = i == _selectedCategory;
                            return _CategoryChip(
                              text: _categories[i],
                              selected: selected,
                              onTap: () => setState(() => _selectedCategory = i),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.68,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _ProductCard(item: _items[index]),
                    childCount: _items.length,
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: SizedBox(height: MediaQuery.of(context).padding.bottom + 10),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.cartCount,
    required this.onCartTap,
    required this.onBackTap,
  });

  final int cartCount;
  final VoidCallback onCartTap;
  final VoidCallback onBackTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: onBackTap,
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFF2F4FA),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE9ECF6)),
            ),
            child: Icon(Icons.chevron_left_rounded,
                size: 22, color: AppColors.textDark.withOpacity(0.9)),
          ),
        ),
        const SizedBox(width: 10),
        Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: const BoxDecoration(
                color: AppColors.primaryBlue,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.storefront_rounded,
                  size: 13, color: Colors.white),
            ),
            const SizedBox(width: 8),
            const Text(
              'Safety Store',
              style: TextStyle(
                color: AppColors.textDark,
                fontSize: 15.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const Spacer(),
        InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: onCartTap,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F4FA),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFE9ECF6)),
                ),
                child: Icon(Icons.shopping_bag_outlined,
                    size: 20, color: AppColors.textDark.withOpacity(0.85)),
              ),
              Positioned(
                right: -2,
                top: -2,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF4D77),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      '$cartCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        height: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.hint});
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4FA),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE9ECF6)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          Icon(Icons.search_rounded, size: 18, color: AppColors.textMuted.withOpacity(0.85)),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  color: AppColors.textMuted.withOpacity(0.75),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                border: InputBorder.none,
                isDense: true,
              ),
              style: const TextStyle(
                color: AppColors.textDark,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              cursorColor: AppColors.primaryBlue,
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  final String text;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryBlue : const Color(0xFFF2F4FA),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: selected ? AppColors.primaryBlue : const Color(0xFFE9ECF6)),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.textMuted.withOpacity(0.95),
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.item});
  final _StoreItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF6F7FB),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE9ECF6)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image
            SizedBox(
              height: 116,
              child: Stack(
                children: [
                  Positioned.fill(child: _ProductImage(style: item.imageStyle)),
                  if (item.favorite)
                    Positioned(
                      right: 10,
                      top: 10,
                      child: Container(
                        width: 26,
                        height: 26,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFE6EF),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.favorite_rounded,
                            size: 14, color: Color(0xFFFF4D77)),
                      ),
                    ),
                  if (item.tag != null)
                    Positioned(
                      left: 10,
                      bottom: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF4D77),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          item.tag!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8.5,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textDark,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, size: 14, color: Color(0xFFFFC542)),
                        const SizedBox(width: 4),
                        Text(
                          '${item.rating.toStringAsFixed(1)} (${item.reviews})',
                          style: TextStyle(
                            color: AppColors.textMuted.withOpacity(0.95),
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${item.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: AppColors.textDark,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      height: 34,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue,
                          borderRadius: BorderRadius.circular(999),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryBlue.withOpacity(0.20),
                              blurRadius: 16,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(999),
                          onTap: () {},
                          child: const Center(
                            child: Text(
                              'Buy Now',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  const _ProductImage({required this.style});
  final _ImageStyle style;

  @override
  Widget build(BuildContext context) {
    // Placeholder “photo-like” styles (swap with Image.asset for true 100% match)
    switch (style) {
      case _ImageStyle.pepperSpray:
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFF7E8A), Color(0xFFFFD3D8)],
            ),
          ),
          child: Center(
            child: Container(
              width: 38,
              height: 74,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.85),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Container(
                  width: 22,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFF111827),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
        );

      case _ImageStyle.siren:
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0B0F14), Color(0xFF1F2937)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Container(
              width: 56,
              height: 74,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Color(0xFF9CA3AF),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );

      case _ImageStyle.keychain:
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0B0F14), Color(0xFF2B3441)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Container(
              width: 74,
              height: 74,
              decoration: BoxDecoration(
                color: const Color(0xFF111827),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Center(
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFF9CA3AF),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF374151), width: 4),
                  ),
                ),
              ),
            ),
          ),
        );

      case _ImageStyle.kit:
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0B0F14), Color(0xFF1F2937)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 56,
                  height: 66,
                  decoration: BoxDecoration(
                    color: const Color(0xFF16A34A),
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFBBF24),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
        );

      case _ImageStyle.stealth:
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFEFF2FF), Color(0xFFFFFFFF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Container(
              width: 40,
              height: 78,
              decoration: BoxDecoration(
                color: const Color(0xFF111827),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        );

      case _ImageStyle.flashlight:
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFEFF2FF), Color(0xFFFFFFFF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Transform.rotate(
              angle: -0.35,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 58,
                    height: 20,
                    decoration: BoxDecoration(
                      color: const Color(0xFF111827),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: const Color(0xFF111827),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
    }
  }
}

enum _ImageStyle { pepperSpray, siren, keychain, kit, stealth, flashlight }

class _StoreItem {
  final String title;
  final double rating;
  final int reviews;
  final double price;
  final String? tag;
  final _ImageStyle imageStyle;
  final bool favorite;

  const _StoreItem({
    required this.title,
    required this.rating,
    required this.reviews,
    required this.price,
    required this.imageStyle,
    this.tag,
    this.favorite = false,
  });
}