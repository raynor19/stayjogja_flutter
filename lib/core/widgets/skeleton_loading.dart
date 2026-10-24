import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWrapper extends StatelessWidget {
  final Widget child;
  const ShimmerWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE2ECE6),
      highlightColor: const Color(0xFFF4FAF6),
      period: const Duration(milliseconds: 1400),
      child: child,
    );
  }
}

class Bone extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const Bone({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

/// Skeleton untuk Hotel Card di Search Page (Screen 2)
class HotelCardSkeleton extends StatelessWidget {
  const HotelCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerWrapper(
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Bone
            const Bone(
              width: double.infinity,
              height: 180,
              borderRadius: 24,
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Bone(width: 180, height: 18, borderRadius: 6),
                      Bone(width: 60, height: 16, borderRadius: 6),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Bone(width: 140, height: 12, borderRadius: 4),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Bone(width: 110, height: 12, borderRadius: 4),
                          SizedBox(height: 6),
                          Bone(width: 130, height: 12, borderRadius: 4),
                        ],
                      ),
                      const Bone(width: 100, height: 38, borderRadius: 20),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Skeleton untuk Featured Offers di Home Page
class FeaturedHotelSkeleton extends StatelessWidget {
  const FeaturedHotelSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerWrapper(
      child: Container(
        width: 220,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Bone(width: 220, height: 145, borderRadius: 20),
            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Bone(width: 150, height: 14, borderRadius: 6),
                  SizedBox(height: 6),
                  Bone(width: 100, height: 10, borderRadius: 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Skeleton untuk Room Detail (Screen 3)
class RoomDetailSkeleton extends StatelessWidget {
  const RoomDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Bone(width: double.infinity, height: 280, borderRadius: 0),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Bone(width: 200, height: 22, borderRadius: 8),
                    Bone(width: 90, height: 14, borderRadius: 6),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: const [
                    Expanded(child: Bone(width: double.infinity, height: 75, borderRadius: 20)),
                    SizedBox(width: 12),
                    Expanded(child: Bone(width: double.infinity, height: 75, borderRadius: 20)),
                    SizedBox(width: 12),
                    Expanded(child: Bone(width: double.infinity, height: 75, borderRadius: 20)),
                  ],
                ),
                const SizedBox(height: 24),
                const Bone(width: double.infinity, height: 140, borderRadius: 24),
                const SizedBox(height: 16),
                const Bone(width: double.infinity, height: 140, borderRadius: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
