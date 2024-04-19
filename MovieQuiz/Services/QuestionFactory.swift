import Foundation

final class QuestionFactory: QuestionFactoryProtocol {
    private var movies: [MostPopularMovie] = []
    private let moviesLoader: MoviesLoading
    private weak var delegate: QuestionFactoryDelegate?
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            
            let index = (0..<self.movies.count).randomElement() ?? 0
            guard let movie = self.movies[safe: index] else { return }
            
            var imageData = Data()
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                DispatchQueue.main.async {
                    self.delegate?.didFailToLoadData(with: NetworkError.imageError)
                    return
                }
            }
            
            let rating = Float(movie.rating) ?? 0
            let comparedRating = rating.generateNumberForComparison()
            
            let questionLogic = generateQuestionLogic(rating: rating, comparedRating: comparedRating)
            let text = questionLogic.0
            let correctAnswer = questionLogic.1
            
            let question = QuizQuestion(image: imageData, text: text, correctAnswer: correctAnswer)
            
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
    
    private func generateQuestionLogic(rating: Float, comparedRating: Float) -> (String, Bool) {
        let random = Int.random(in: 0...1)
        if random > 0 {
            return ("Рейтинг этого фильма больше чем \(String(format: "%.1f", comparedRating))?", rating > comparedRating)
        } else {
            return ("Рейтинг этого фильма меньше чем \(String(format: "%.1f", comparedRating))?", rating < comparedRating)
        }
    }
}
