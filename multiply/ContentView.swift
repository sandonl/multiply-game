//
//  ContentView.swift
//  multiply
//
//  Created by Sandon Lai on 5/3/21.
//

import SwiftUI

struct ContentView: View {
    
    // Game and state related properties
    @State private var gameIsActive = false
    
    @State private var resultAlert = false
    
    @State private var displayAnimal = ""
    
    @State private var questions = [Question]()
    
   
    // Quiz related properties
    @State private var chosenMultiple = 2
    
    @State private var userSelectQuestions = ""
    
    @State private var currentQuestion = ""
    
    @State private var currentAnswer = ""
    
    @State private var userAnswer = ""
    
    // Alert properties
    @State private var showingAlert = false
    
    @State private var alertMessage = ""
    
    @State private var alertTitle = ""
    
    // Scoring and Animation
    @State private var userScore = 0
    
    @State private var animateImage = false
    
    // Number of Questions available in picker
    var numberOfQuestions = ["5", "10", "15", "20", "All"]
    
    // Background Colors and Elements
    let bgColor = Color(red: 138/255, green: 194/255, blue: 255/255)
    
    let circleColor = Color(red: 128/255, green: 181/255, blue: 237/255)
    
    let rectangleColor = Color(red: 109/255, green: 171/255, blue: 237/255)
    
    let images = ["bear", "buffalo", "chick", "chicken", "cow", "crocodile", "dog", "duck", "elephant", "frog", "hippo", "panda", "parrot"]
    
    init () {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    var body: some View {
        NavigationView{
            
            Group {
                ZStack {
                    // Background Colour and Background Elements
                    bgColor
                
                    Circle()
                        .foregroundColor(circleColor)
                        .frame(width: 300, height: 300)
                        .offset(x: 80, y: 210)
                        
                    
                    Rectangle()
                        .foregroundColor(rectangleColor)
                        .frame(width: 300, height: 500)
                        .rotationEffect(Angle(degrees: 80))
                        .offset(y: 350)
                    
                    Group {
                        if !gameIsActive {
                            VStack (spacing: 20){
                                Section {
                                    Image("bear")
                                    
                                    // Text to display current multiply number.
                                    Text("Practice which table?:  \(chosenMultiple)")
                                        .titleStyle()
                                    
                                    Stepper("Current number:", value: $chosenMultiple, in: 2...12)
                                        .labelsHidden()
                                        
                                }
                                
                                Section {
                                    Text("How many questions?")
                                        .titleStyle()
                                        .foregroundColor(Color.white)
                                    
                                    Picker("Number of questions", selection: $userSelectQuestions) {
                                        ForEach(numberOfQuestions, id: \.self) {
                                            Text($0)
                                        }
                                    }
                                    .frame(width: 300, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                    .pickerStyle(SegmentedPickerStyle())
                                    .colorInvert()
                                    
                                    
                                    Button(action: {
                                        generateQuestions(currentMultiple: chosenMultiple, numberOfQuestions: userSelectQuestions)
                                        gameIsActive = true
                                        displayQuestion()

                                    }) {
                                        Text("Start Game")
                                            .buttonStyle()
                                        
                                    }
                                }
                                
                            }
                        } else {
                            VStack {
                                // MARK: TODO - Add animations
                                Image(displayAnimal)
                                    // Correct answers will flip the animal around
                                .rotation3DEffect(.degrees((self.userAnswer == self.currentAnswer) && animateImage ? 360 : 0), axis: (x: 0, y: 1, z: 0))
                                
                                
                                Text(currentQuestion)
                                    .titleStyle()

                                TextField("?", text: $userAnswer)
                                    .frame(width: 100, height: 60)
                                    .textBox()
                                    .titleStyle()
                                    
                                    
                                
                                Button(action: {
                                    
                                    withAnimation {
                                        animateImage.toggle()
                                    }
                                    checkAnswer()
                                    showingAlert = true
                                    displayQuestion()
                                    
                                }) {
                                    Text("Guess!")
                                        .buttonStyle()
                                }
                                
                            }
                        }
                        
                    }
                    
                }
                .navigationTitle("Multiply!")
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("Ok Got it!")))
                }
                .ignoresSafeArea()
            }
        }
            
    }
    
    // Generates the questions to be used
    func generateQuestions(currentMultiple: Int, numberOfQuestions: String) {
        
        var numberToGenerate = 0
        // Counter for other combinations of multiples
        var i = 2
                
        switch numberOfQuestions {
        case "All":
            numberToGenerate = 30
        default:
            numberToGenerate = Int(numberOfQuestions) ?? 5
        }
        
        for _ in 1...numberToGenerate {
            questions.append(Question(question: "What is \(currentMultiple) x \(i) = ?", answer: String(currentMultiple*i)))
            i += 1
            questions.shuffle()
        }

    }
    
    // Displays the next question in the array (works backwards)
    func displayQuestion() {
        // Game is now over, reset score and messages
        guard !questions.isEmpty else {
            gameIsActive = false
            showingAlert = true
            alertMessage = "Game Over! You got \(userScore) out of \(userSelectQuestions) correct"
            alertTitle = "Game Over!"
            userScore = 0
            return
        }
        
        displayAnimal = images.randomElement() ?? "owl"
        currentQuestion = questions.last?.question ?? "Error."
        currentAnswer = questions.last?.answer ?? "Error."
        
        // Removes the last question from the array
        questions.removeLast()
        
    }
    
    func checkAnswer() {
        if userAnswer == currentAnswer {
            alertMessage = "Good Job"
            alertTitle = "Correct!"
            userScore += 1
            
        } else {
            alertMessage = "Hmm... not quite! the correct answer was \(currentAnswer)"
            alertTitle = "Not Quite!"
        }
        
        // Clears the userAnswer after checking
        userAnswer = ""
        
    }

}

// Custom View Modifiers
struct Buttonify: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.init(red: 255/255, green: 182/255, blue: 79/255))
            .cornerRadius(20)
            .shadow(radius: 1, x: 0.0, y: 1)
            .font(.system(size: 30, weight: .heavy, design: .default))
            .foregroundColor(.white)
            .offset(y: 20)
    }
}


struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 25, weight: .heavy, design: .default))
            .foregroundColor(.white)
            .padding()
    }
}

struct TextBox: ViewModifier {
    func body(content: Content) -> some View {
        content
            .border(Color(red: 164, green: 165, blue: 166))
            .background(Color(red: 206, green: 213, blue: 224))
            .foregroundColor(.black)
            .multilineTextAlignment(.center)
            .cornerRadius(20)
            .keyboardType(.decimalPad)
            
    }
}

extension View {
    func textBox() -> some View {
        self.modifier(TextBox())
    }
}

extension View {
    func titleStyle() -> some View {
        self.modifier(Title())
    }
}

extension View {
    func buttonStyle() -> some View {
        self.modifier(Buttonify())
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
