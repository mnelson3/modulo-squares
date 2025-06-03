// /Users/marknelson/Circus/Repositories/modulo_flutter_project/lib/src/features/profile/data/repositories/profile_repository_impl.dart

import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';
import '../models/user_profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  // final ProfileLocalDataSource localDataSource; // Optional: for caching

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    // required this.localDataSource,
  });

  @override
  Future<UserProfile?> getUserProfile(String userId) async {
    try {
      // Optional: Check local cache first
      // final localProfile = await localDataSource.getUserProfile(userId);
      // if (localProfile != null) return localProfile.toEntity();

      final remoteProfileModel = await remoteDataSource.getUserProfile(userId);
      if (remoteProfileModel != null) {
        // Optional: Cache the fetched profile
        // await localDataSource.cacheUserProfile(remoteProfileModel);
        // If UserProfileModel is not a direct extension of UserProfile, map it:
        // return remoteProfileModel.toEntity();
        return remoteProfileModel; // Assuming UserProfileModel can be directly used as UserProfile
      }
      return null;
    } catch (e) {
      // Handle exceptions, perhaps map to domain-specific errors
      // For example, throw NetworkException() or UserNotFoundException()
      print('ProfileRepositoryImpl: Error getting user profile: $e');
      rethrow; // Or return null / throw a domain-specific error
    }
  }

  @override
  Future<void> updateUserProfile(String userId, UserProfile profile) async {
    try {
      final profileModel = UserProfileModel(id: profile.id, displayName: profile.displayName, email: profile.email, photoUrl: profile.photoUrl, highScore: profile.highScore); // Map entity to model
      await remoteDataSource.updateUserProfile(userId, profileModel);
      // Optional: Update local cache
      // await localDataSource.cacheUserProfile(profileModel);
    } catch (e) {
      print('ProfileRepositoryImpl: Error updating user profile: $e');
      rethrow;
    }
  }
}
