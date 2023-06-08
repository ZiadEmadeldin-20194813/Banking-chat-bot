<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="chatbot.aspx.cs" Inherits="ChatbotDemo.chatbot" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>FNB chatbot</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        /* Center chatbot container */
        .chatbot-container {
            margin: 0 auto;
            max-width: 600px;
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0px 0px 10px 1px rgba(0, 0, 0, 0.2);
        }

        /* Style chatbot elements */
        .chatbot-label {
            font-weight: bold;
        }

        .chatbot-input {
            width: 100%;
            padding: 12px 20px;
            margin: 8px 0;
            box-sizing: border-box;
            border-radius: 5px;
            border: none;
            background-color: #f1f1f1;
            font-size: 16px;
        }

        .chatbot-input:focus {
            outline: none;
        }

        .chatbot-button {
            background-color: #a70000;
            color: white;
            padding: 12px 20px;
            border-radius: 5px;
            border: none;
            cursor: pointer;
            font-size: 16px;
            margin-left: 10px;
        }

        .chatbot-button:hover {
            background-color: #dd0000;
        }

        .chatbot-message-container {
            margin-bottom: 10px;
            overflow: auto;
            height: 400px;
            padding: 10px;
            background-color: white;
            border-radius: 5px;
            box-shadow: 0px 0px 10px 1px rgba(0, 0, 0, 0.2);
        }

        .chatbot-user-message {
            background-color: #f5f5f5;
            border-radius: 5px;
            padding: 10px;
            margin-left: 30%;
            max-width: 70%;
            text-align: right;
            margin-bottom: 10px;
        }

        .chatbot-bot-message {
            background-color: #a70000;
            color: white;
            border-radius: 5px;
            padding: 10px;
            margin-right: 30%;
            max-width: 70%;
            text-align: left;
            margin-bottom: 10px;
            position: relative;
        }

        .chatbot-audio-button {
            position: absolute;
            top: 50%;
            right: -40px;
            transform: translateY(-50%);
            background-color: #a70000;
            color: white;
            padding: 5px;
            border-radius: 50%;
            border: none;
            cursor: pointer;
            font-size: 16px;
            display: flex;
            justify-content: center;
            align-items: center;
            width: 30px;
            height: 30px;
        }

        .chatbot-audio-button:hover {
            background-color: #dd0000;
        }
    </style>
    <script type="text/javascript">
        function sendQuestion() {
            var question = document.getElementById("question").value;
            $.ajax({
                url: "chatbot.aspx/GetAnswer",
                data: JSON.stringify({ question: question }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                type: "POST",
                success: function (result) {
                    // Create user message element
                    var userMessage = document.createElement("div");
                    userMessage.classList.add("chatbot-user-message");
                    userMessage.innerHTML = question;

                    // Create bot message element
                    var botMessage = document.createElement("div");
                    botMessage.classList.add("chatbot-bot-message");
                    botMessage.innerHTML = result.d;

                    // Add audio button to bot message
                    var audioButton = document.createElement("button");
                    audioButton.classList.add("chatbot-audio-button");
                    audioButton.innerHTML = "&#x1f50a;";
                    audioButton.setAttribute("onclick", "speakAnswer('" + result.d + "')");
                    botMessage.appendChild(audioButton);

                    // Add messages to container
                    var messageContainer = document.getElementById("messageContainer");
                    messageContainer.appendChild(userMessage);
                    messageContainer.appendChild(botMessage);

                    //Scroll to bottom of container
                    messageContainer.scrollTop = messageContainer.scrollHeight;

                    // Clear input field
                    document.getElementById("question").value = "";
                },
                error: function (xhr, status, error) {
                    console.log(xhr.responseText);
                }
            });
        }

        function speakAnswer(answer) {
            var speech = new SpeechSynthesisUtterance();
            speech.text = answer;
            window.speechSynthesis.speak(speech);
        }
    </script>
</head>
<body>
    <div class="chatbot-container">
        <h1 style="text-align:center;">FNB chatbot</h1>
        <div id="messageContainer" class="chatbot-message-container">
            <!-- Bot message will be added here -->
        </div>
        <div style="display:flex; justify-content:center; align-items:center;">
            <input class="chatbot-input" type="text" id="question" placeholder="Ask me anything...">
            <button class="chatbot-button" type="button" id="sendButton" onclick="sendQuestion()">Send</button>
        </div>
    </div>
</body>
</html>