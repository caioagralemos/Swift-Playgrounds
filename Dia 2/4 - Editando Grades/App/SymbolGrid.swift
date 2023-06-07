import SwiftUI
//#-learning-task(symbolGrid)

struct SymbolGrid: View {
    //#-learning-code-snippet(addStatePropertyIsAddingSymbol)
    //#-learning-code-snippet(statePropertyIsEditing)
    private static let initialColumns = 3
    @State private var selectedSymbol: Symbol?
    @State private var numColumns = initialColumns
    @State private var gridColumns = Array(repeating: GridItem(.flexible(minimum: 100, maximum: 200)), count: initialColumns)
    
    @State private var isAddingSymbol = false
    @State private var isEditing = false
    
    /*#-code-walkthrough(3.symbolNames)*/
    @State private var symbols = [
        Symbol(name: "tshirt"),
        Symbol(name: "eyes"),
        Symbol(name: "eyebrow"),
        Symbol(name: "nose"),
        Symbol(name: "mustache"),
        Symbol(name: "mouth"),
        Symbol(name: "eyeglasses"),
        Symbol(name: "facemask"),
        Symbol(name: "brain.head.profile"),
        Symbol(name: "brain"),
        Symbol(name: "icloud"),
        Symbol(name: "theatermasks.fill"),
        Symbol(name: "soccerball.inverse"),
        Symbol(name: "moon.stars"),
        Symbol(name: "iphone")
    ]

    /*#-code-walkthrough(3.symbolNames)*/
    
    var body: some View {
        VStack {
            ScrollView{
                if isEditing {
                    Stepper(columnsText, value: $numColumns, in: 1...6, step: 1) { _ in
                        // func pra aumentar o tamanho de colunas
                        withAnimation { gridColumns = Array(repeating: GridItem(.flexible()), count: numColumns) }
                    }
                    .padding()
                }
                /*#-code-walkthrough(3.lazyVGrid)*/
                LazyVGrid (columns: gridColumns){
                    ForEach(symbols) { simb in
                        NavigationLink() {
                            SymbolDetail(symbol: simb)  
                        } label: {
                            Image(systemName: simb.name)
                                .resizable()
                                .scaledToFit()
                                .symbolRenderingMode(.hierarchical)
                                .foregroundColor(.gray)
                        }.overlay(alignment: .topTrailing) {
                            if isEditing {
                                Button {
                                    remove(symbol: simb)
                                } label: {
                                    Image(systemName: "xmark.square.fill")
                                        .font(.title)
                                        .symbolRenderingMode(.palette)
                                        .foregroundStyle(.white, Color.red)
                                }
                            }
                        }
                    }
                }
            }
        }.padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, 20) 
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isAddingSymbol = true
                    } label: {
                        Image(systemName: "plus")
                    }
                } 
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(isEditing ? "Ok": "Edit"){
                        withAnimation {
                            isEditing.toggle()
                        }
                    }
                }
            }.sheet(isPresented: $isAddingSymbol, onDismiss: addSymbol) { 
                // $var (valor de vinculo) é como uma referencia ou um ponteiro pra um valor
                // visa manter uma única fonte da verdade              
                SymbolPicker(symbol: $selectedSymbol)
            }
        //#-learning-code-snippet(sheet)
    }
    
    func addSymbol() {
        guard let name = selectedSymbol else { return }
        withAnimation {
            symbols.insert(name, at: 0)
        }
    }
    
    func remove(symbol: Symbol) {
        guard let index = symbols.firstIndex(of: symbol) else { return }
        withAnimation {
            _ = symbols.remove(at: index)
        }
    }
}

extension SymbolGrid {
    var columnsText: String {
        numColumns > 1 ? "\(numColumns) Columns" : "1 Column"
    }
}
