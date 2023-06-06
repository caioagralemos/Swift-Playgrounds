import Foundation

let assessChangeText = CodeSyntaxQuery(id: "assessChangeText") {
    Structure("IntroView") {
        Variable("body") {
            FunctionCall("Text", containingText: "^((?!Hello, friend).)*$")
        }
    }
}

let assessTextElement = CodeSyntaxQuery(id: "assessTextElement") {
    Structure("IntroView") {
        Variable("body") {
            CountOf(2) {
                FunctionCall("Text", containingText: "^((?!friend).)*")
            }
        }
    }
}

let assessAddFriend = CodeSyntaxQuery(id: "assessAddFriend") {
    Structure("IntroView") {
        Variable("body") {
            FunctionCall("Image", containingText: "\"FriendAndGem\"")
            .modifier("resizable")
        }
    }
}

let imageFriendAndGemResizableScaledToFit =
FunctionCall("Image", containingText: "\"FriendAndGem\"")
    .modifier("resizable")
    .modifier("scaledToFit")

let assessModifier = CodeSyntaxQuery(id: "assessModifier") {
    Structure("IntroView") {
        Variable("body") {
            imageFriendAndGemResizableScaledToFit
        }
    }
}

let assessPlaceOneViewInsideAnother = CodeSyntaxQuery(id: "assessAddAVStack") {
    Structure("IntroView") {
        Variable("body") {
            FunctionCall("HStack") {
                FunctionCall(matching: "Text|Image")
            }
        }
    }
}

let assessAddImageInHStack = CodeSyntaxQuery(id: "assessAddImageInHStack") {
    Structure("IntroView") {
        Variable("body") {
            FunctionCall("HStack") {
                FunctionCall(matching: "Text|Image", containingText: "\".+\"")
                imageFriendAndGemResizableScaledToFit
            }
            NoneOf {
                imageFriendAndGemResizableScaledToFit
            }
        }
    }
}

let imageFriendResizableScaledToFit =
FunctionCall("Image", containingText: "\"Friend\"")
    .modifier("resizable")
    .modifier("scaledToFit")

let assessComposeAView = CodeSyntaxQuery(id: "assessComposeAView") {
    Structure("FriendDetailView") {
        Variable("body") {
            FunctionCall("VStack") {
                FunctionCall("HStack") {
                    imageFriendResizableScaledToFit
                }
                NoneOf {
                    imageFriendResizableScaledToFit
                }
            }
        }
    }
}

let assessAddVStackInHStack = CodeSyntaxQuery(id: "assessAddVStackInHStack") {
    Structure("FriendDetailView") {
        Variable("body") {
            FunctionCall("VStack") {
                FunctionCall("HStack") {
                    imageFriendResizableScaledToFit
                    FunctionCall("VStack")
                }
            }
        }
    }
}

let assessAddTextInVStack = CodeSyntaxQuery(id: "assessAddTextInVStack") {
    Structure("FriendDetailView") {
        Variable("body") {
            FunctionCall("VStack") {
                FunctionCall("HStack") {
                    imageFriendResizableScaledToFit
                    FunctionCall("VStack") {
                        FunctionCall("Text", containingText: "\".+\"")
                            .modifier("font", arguments: [
                                Argument(Member("largeTitle"))
                            ])
                    }
                }
            }
        }
    }
}

let assessDescribeFriend = CodeSyntaxQuery(id: "assessDescribeFriend") {
    Structure("FriendDetailView") {
        Variable("body") {
            FunctionCall("VStack") {
                FunctionCall("HStack") {
                    imageFriendResizableScaledToFit
                    FunctionCall("VStack") {
                        FunctionCall("Text", containingText: "\".+\"")
                            .modifier("font", arguments: [
                                Argument(Member("largeTitle"))
                            ])
                        FunctionCall("Text", containingText: "\".+\"")
                            .modifier("font", arguments: [
                                Argument(Member("caption"))
                            ])
                    }
                }
            }
        }
    }
}

let assessCreateDetailView = CodeSyntaxQuery(id: "assessCreateDetailView") {
    Structure("ExperimentView") {
        Variable("body") {
            FunctionCall("VStack") {
                FunctionCall("FriendDetailView")
            }
        }
    }
}

