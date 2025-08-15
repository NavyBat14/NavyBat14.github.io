import 'package:flutter/material.dart';

/// ----------------- User Data -----------------

/// Enum for user tiers
enum UserTier { bronze, silver, gold, platinum }

/// User data model
class UserData {
  final String name;
  final String email;
  int miles;

  UserData({required this.name, required this.email, this.miles = 0});

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      miles: map['miles'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'email': email, 'miles': miles};
  }

  /// Determine user tier based on miles
  UserTier get tier {
    if (miles >= 50000) return UserTier.platinum;
    if (miles >= 30000) return UserTier.gold;
    if (miles >= 15000) return UserTier.silver;
    return UserTier.bronze;
  }
}

/// ----------------- Reward Data -----------------

class Reward {
  final String id;
  final String title;
  final String description;
  final int milesRequired;
  final String image;
  final String category;
  final bool featured;
  final UserTier? tierRequired;

  const Reward({
    required this.id,
    required this.title,
    required this.description,
    required this.milesRequired,
    required this.image,
    required this.category,
    this.featured = false,
    this.tierRequired,
  });
}

/// Mock rewards
const List<Reward> mockRewards = [
  Reward(
    id: 'r1',
    title: 'Free Checked Bag',
    description: 'Get one free checked bag on your next flight',
    milesRequired: 5000,
    image:
        'https://images.unsplash.com/photo-1596394516093-501ba68a0ba6?w=400&h=300&fit=crop',
    category: 'Travel Benefits',
    featured: true,
  ),
  Reward(
    id: 'r2',
    title: 'Priority Boarding',
    description: 'Board before general boarding on your next flight',
    milesRequired: 3000,
    image:
        'https://images.unsplash.com/photo-1436491865332-7a61a109cc05?w=400&h=300&fit=crop',
    category: 'Airport Services',
    featured: true,
  ),
  Reward(
    id: 'r3',
    title: 'Economy to Business Upgrade',
    description: 'Upgrade from Economy to Business class',
    milesRequired: 15000,
    image:
        'https://images.unsplash.com/photo-1540339832862-474599807836?w=400&h=300&fit=crop',
    category: 'Upgrades',
    tierRequired: UserTier.silver,
  ),
  Reward(
    id: 'r4',
    title: 'Airport Lounge Access',
    description: 'One-time access to premium airport lounges',
    milesRequired: 8000,
    image:
        'https://images.unsplash.com/photo-1545128485-c400e7702796?w=400&h=300&fit=crop',
    category: 'Airport Services',
    tierRequired: UserTier.silver,
  ),
];
