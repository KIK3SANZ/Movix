import CoreData

class CoreDataHelper {
    static let shared = CoreDataHelper()

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = CoreDataManager.shared.context) {
        self.context = context
    }
    
    func saveFavoriteMovie(_ movie: Movie) {
        let favoriteMovie = FavoriteMovie(context: context)
        favoriteMovie.id = Int64(movie.id)
        favoriteMovie.title = movie.title
        favoriteMovie.releaseDate = movie.releaseDate
        favoriteMovie.overview = movie.overview
        favoriteMovie.posterPath = movie.posterPath
        favoriteMovie.popularity = movie.popularity

        do {
            try context.save()
        } catch {
            print("Failed to save movie: \(error.localizedDescription)")
        }
    }

    func fetchFavoriteMovies() -> [Movie] {
        let fetchRequest: NSFetchRequest<FavoriteMovie> = FavoriteMovie.fetchRequest()
        do {
            let favoriteMovies = try context.fetch(fetchRequest)
            return favoriteMovies.map { favoriteMovie in
                return Movie(id: Int(favoriteMovie.id), title: favoriteMovie.title ?? "", overview: favoriteMovie.overview ?? "", posterPath: favoriteMovie.posterPath ?? "", originalLanguage: favoriteMovie.originalLanguage ?? "", voteCount: Int(favoriteMovie.voteCount), releaseDate: favoriteMovie.releaseDate ?? "", popularity: favoriteMovie.popularity, isFavorite: true)
            }
        } catch {
            print("Failed to fetch favorite movies: \(error.localizedDescription)")
            return []
        }
    }

    func deleteFavoriteMovie(by id: Int) {
        let fetchRequest: NSFetchRequest<FavoriteMovie> = FavoriteMovie.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        do {
            let favoriteMovies = try context.fetch(fetchRequest)
            if let movieToDelete = favoriteMovies.first {
                context.delete(movieToDelete)
                try context.save()
            }
        } catch {
            print("Failed to delete movie: \(error.localizedDescription)")
        }
    }

    func isMovieFavorite(id: Int) -> Bool {
        let fetchRequest: NSFetchRequest<FavoriteMovie> = FavoriteMovie.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)

        do {
            let favoriteMovies = try context.fetch(fetchRequest)
            return !favoriteMovies.isEmpty
        } catch {
            print("Failed to fetch movie: \(error.localizedDescription)")
            return false
        }
    }
}
