<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Rohini ChatBot</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <style>
        :root {
            --bg-color: #121212;
            --text-color: white;
            --card-color: #1e1e1e;
            --msg-bg: #1e1e1e;
        }

        body {
            background-color: var(--bg-color);
            color: var(--text-color);
            transition: background-color 0.3s ease, color 0.3s ease;
        }

        .chat-wrapper {
            max-width: 450px;
            margin: 30px auto;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 0 15px #ba00e5;
            background-color: var(--card-color);
        }

        .chat-header {
            padding: 15px;
            background: linear-gradient(to right, #ff00cc, #3333ff);
            color: white;
            font-size: 1.2rem;
            font-weight: bold;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .chat-messages {
            height: 500px;
            overflow-y: auto;
            padding: 15px;
            background-color: var(--msg-bg);
        }

        .message {
            margin-bottom: 10px;
            display: flex;
        }

        .message.bot {
            justify-content: flex-start;
        }

        .message.user {
            justify-content: flex-end;
        }

        .message span, .bot-content {
            padding: 10px 15px;
            border-radius: 20px;
            max-width: 75%;
        }

        .message.user span {
            background-color: #0fd979;
            color: white;
        }

        .bot-content {
            background-color: #3a3a3a;
            color: white;
            animation: typing 0.5s steps(30, end);
        }

        .bot-typing {
            font-style: italic;
            color: gray;
            font-size: 14px;
            margin-bottom: 10px;
        }

        @keyframes typing {
            from { width: 0; }
            to { width: 100%; }
        }

        .chat-footer {
            padding: 10px;
            background-color: var(--card-color);
        }

        .tick {
            font-size: 12px;
            margin-left: 5px;
            color: #34b7f1;
        }

        .input-group-text {
            background: #444;
            border: none;
            color: white;
        }

        .dark-mode {
            --bg-color: #121212;
            --text-color: white;
            --card-color: #1e1e1e;
            --msg-bg: #1e1e1e;
        }

        .light-mode {
            --bg-color: #f8f9fa;
            --text-color: black;
            --card-color: white;
            --msg-bg: #f1f1f1;
        }

.custom-btn {
    border: none;
    border-radius: 20px;
    padding: 6px 12px;
    margin-right: 5px;
    font-weight: bold;
    color: white;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
    transition: all 0.3s ease-in-out;
}

.emoji-btn {
    background: linear-gradient(to right, #f39c12, #f1c40f);
}

.attach-btn {
    background: linear-gradient(to right, #8e44ad, #9b59b6);
}

.mic-btn {
    background: linear-gradient(to right, #e74c3c, #ff6f61);
}

.send-btn {
    background: linear-gradient(to right, #00c853, #00e676);
    padding: 6px 18px;
}

.custom-btn:hover {
    transform: scale(1.05);
    box-shadow: 0 6px 16px rgba(0, 0, 0, 0.3);
}

.form-control {
    border-radius: 20px;
    padding: 10px;
    background-color: #2a2a2a;
    color: white;
    border: 1px solid #444;
}

    </style>
</head>
<body>

<div class="chat-wrapper">
    <!-- Header -->
    <div class="chat-header">
        <div class="font-weight-bold">Rohini ChatBot</div>
        <div>
            <button class="btn btn-sm btn-light" onclick="toggleDarkMode()">🌙</button>
        </div>
    </div>

    <!-- Messages -->
    <div class="chat-messages" id="chatMessages">
        <c:forEach var="msg" items="${chatHistory}">
            <div class="message ${msg.role}">
                <c:choose>
                    <c:when test="${msg.role == 'bot'}">
                        <div class="bot-content markdown-content" data-content="${fn:escapeXml(msg.content)}"></div>
                    </c:when>
                    <c:otherwise>
                        <span>${msg.content}</span>
                        <span class="tick">✓✓</span>
                    </c:otherwise>
                </c:choose>
            </div>
        </c:forEach>
        <div id="typingIndicator" class="bot-typing d-none">Bot is typing...</div>
    </div>

    <!-- Footer -->
    <!-- <div class="chat-footer">
        <form action="send" method="get" id="chatForm">
            <div class="input-group">
                <div class="input-group-prepend">
                    <button class="input-group-text" id="emojiBtn" onclick="toggleEmojiPicker()" type="button">😊</button>
                    <label class="input-group-text" for="fileInput">📎</label>
                    <input type="file" id="fileInput" style="display:none;">
                </div>
                <input type="text" id="chatInput" name="querybox" class="form-control" placeholder="Type a message" required autocomplete="off">
                <div class="input-group-append">
                    <button class="btn btn-secondary" type="button" onclick="startVoiceInput()">🎤</button>
                    <button class="btn btn-success" type="submit">Send</button>
                </div>
            </div>
        </form>
    </div> -->
    <div class="chat-footer">
    <form action="send" method="get" id="chatForm">
        <div class="input-group d-flex align-items-center">
            <button class="btn custom-btn emoji-btn" id="emojiBtn" type="button" onclick="toggleEmojiPicker()">😊</button>
            <label for="fileInput" class="btn custom-btn attach-btn">📎</label>
            <input type="file" id="fileInput" style="display:none;">

            <input type="text" id="chatInput" name="querybox" class="form-control mx-2" placeholder="Type a message" required autocomplete="off">

            <button class="btn custom-btn mic-btn" type="button" onclick="startVoiceInput()">🎤</button>
            <button class="btn custom-btn send-btn" type="submit">Send 🚀</button>
        </div>
    </form>
</div>

    
</div>

<!-- JS Libraries -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/marked/marked.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@joeattardi/emoji-button@4.6.4/dist/index.min.js"></script>

<script>
    // Auto-scroll
    const chatMessages = document.getElementById('chatMessages');
    chatMessages.scrollTop = chatMessages.scrollHeight;

    // Markdown Rendering
    document.querySelectorAll('.markdown-content').forEach(div => {
        const raw = div.getAttribute('data-content');
        div.innerHTML = marked.parse(raw);
    });

    // Dark Mode
    function toggleDarkMode() {
        const body = document.body;
        const isDark = body.classList.contains("dark-mode");
        body.classList.toggle("dark-mode", !isDark);
        body.classList.toggle("light-mode", isDark);
        localStorage.setItem("theme", isDark ? "light" : "dark");
    }

    window.onload = function () {
        const savedTheme = localStorage.getItem("theme") || "dark";
        document.body.classList.add(savedTheme + "-mode");
    }

    // Typing animation simulation
    const typingIndicator = document.getElementById('typingIndicator');
    const chatForm = document.getElementById('chatForm');
    chatForm.addEventListener('submit', () => {
        typingIndicator.classList.remove('d-none');
        setTimeout(() => {
            typingIndicator.classList.add('d-none');
        }, 2000); // simulate 2 sec delay
    });
  
        function toggleEmojiPicker() {
        const picker = document.getElementById("emojiPicker");
        picker.style.display = picker.style.display === "block" ? "none" : "block";

        if (picker.dataset.loaded === "true") return; // load only once

        const emojis = ["😀", "😎", "😂", "😍", "😢", "😡", "👍", "🙏", "🎉", "🔥", "🥳", "🤖"];
        emojis.forEach(e => {
            const span = document.createElement("span");
            span.innerText = e;
            span.style.cursor = "pointer";
            span.style.margin = "6px";
            span.style.fontSize = "24px";
            span.onclick = () => {
                document.getElementById("chatInput").value += e;
                picker.style.display = "none";
            };
            picker.appendChild(span);
        });

        picker.dataset.loaded = "true";
    }

    // Hide picker if clicked outside
    document.addEventListener("click", function (e) {
        const picker = document.getElementById("emojiPicker");
        const btn = document.getElementById("emojiBtn");
        if (!picker.contains(e.target) && !btn.contains(e.target)) {
            picker.style.display = "none";
        }
    });
    // Voice Input
    function startVoiceInput() {
        const recognition = new (window.SpeechRecognition || window.webkitSpeechRecognition)();
        recognition.lang = 'en-US';
        recognition.start();

        recognition.onresult = function(event) {
            document.getElementById('chatInput').value = event.results[0][0].transcript;
        };

        recognition.onerror = function(event) {
            alert('Voice input error: ' + event.error);
        };
    }
</script>
</body>
</html>
