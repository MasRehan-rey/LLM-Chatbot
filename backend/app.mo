import LLM "mo:llm";
import Text "mo:base/Text";
import Debug "mo:base/Debug";
import Array "mo:base/Array";

actor {

  // Gunakan angka tetap dulu, karena Motoko belum punya random native
  stable var secretNumber : Nat = 42;

  public func startGame() : async Text {
    secretNumber := 42; // Angka tetap dulu
    return "Game dimulai! Saya sudah memilih angka antara 1 dan 100. Coba tebak!";
  };

  public func guessNumber(tebakan : Nat) : async Text {
    if (tebakan < secretNumber) {
      return "Terlalu kecil!";
    } else if (tebakan > secretNumber) {
      return "Terlalu besar!";
    } else {
      return "🎉 Benar! Kamu menebak angka " # Nat.toText(secretNumber) # "!";
    }
  };

  // LLM Chat (format benar)
  public func chat(messages : [LLM.ChatMessage]) : async Text {
    let systemPrompt : LLM.ChatMessage = {
      role = #system;
      content = ?("Kamu adalah host game 'Tebak Angka' antara 1–100. Jawab seperti chatbot game yang ramah dan menyenangkan.");
    };

    let fullMessages = Array.append<LLM.ChatMessage>([systemPrompt], messages);

    let response = await LLM.chat({
      model = #Llama3_1_8B;
      messages = fullMessages;
    });

    switch (response.message.content) {
      case (?text) text;
      case null => "Maaf, saya tidak mengerti.";
    }
  };
};
