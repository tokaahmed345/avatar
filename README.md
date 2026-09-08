<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>AI Avatar App — README</title>
<style>
  :root{
    --bg:#0d1117;
    --panel:#161b22;
    --border:#30363d;
    --text:#c9d1d9;
    --heading:#f0f6fc;
    --accent:#58a6ff;
    --accent2:#3fb950;
    --tag-bg:#1f2937;
  }
  *{box-sizing:border-box;}
  body{
    background:var(--bg);
    color:var(--text);
    font-family:"Segoe UI", "Helvetica Neue", Arial, sans-serif;
    line-height:1.65;
    margin:0;
    padding:0 0 60px 0;
  }
  .container{
    max-width:860px;
    margin:0 auto;
    padding:40px 24px;
  }
  h1{
    color:var(--heading);
    font-size:2.1em;
    margin-bottom:4px;
  }
  .subtitle{
    color:#8b949e;
    font-size:1.05em;
    margin-bottom:20px;
  }
  .badges{
    margin:16px 0 28px 0;
  }
  .badge{
    display:inline-block;
    background:var(--tag-bg);
    color:var(--accent);
    border:1px solid var(--border);
    border-radius:6px;
    padding:4px 10px;
    font-size:0.8em;
    margin:0 6px 6px 0;
  }
  h2{
    color:var(--heading);
    border-bottom:1px solid var(--border);
    padding-bottom:8px;
    margin-top:42px;
    font-size:1.4em;
  }
  h3{
    color:var(--heading);
    margin-top:26px;
    font-size:1.1em;
  }
  p{ margin:12px 0; }
  ul, ol{ padding-left:22px; }
  li{ margin:6px 0; }
  code{
    background:var(--tag-bg);
    color:#e6edf3;
    padding:2px 6px;
    border-radius:4px;
    font-family:"Consolas","Monaco",monospace;
    font-size:0.9em;
  }
  pre{
    background:var(--panel);
    border:1px solid var(--border);
    border-radius:8px;
    padding:16px;
    overflow-x:auto;
  }
  pre code{
    background:none;
    padding:0;
  }
  .panel{
    background:var(--panel);
    border:1px solid var(--border);
    border-radius:10px;
    padding:20px 24px;
    margin:20px 0;
  }
  table{
    width:100%;
    border-collapse:collapse;
    margin:16px 0;
  }
  th, td{
    border:1px solid var(--border);
    padding:8px 12px;
    text-align:left;
    font-size:0.95em;
  }
  th{
    background:var(--tag-bg);
    color:var(--heading);
  }
  .flow{
    display:flex;
    flex-wrap:wrap;
    gap:10px;
    align-items:center;
    margin:20px 0;
  }
  .step{
    background:var(--tag-bg);
    border:1px solid var(--border);
    border-radius:8px;
    padding:10px 14px;
    font-size:0.9em;
    color:var(--accent);
    white-space:nowrap;
  }
  .arrow{
    color:#8b949e;
    font-size:1.2em;
  }
  a{ color:var(--accent); text-decoration:none; }
  a:hover{ text-decoration:underline; }
  hr{
    border:none;
    border-top:1px solid var(--border);
    margin:40px 0;
  }
  .footer{
    color:#8b949e;
    font-size:0.9em;
    text-align:center;
    margin-top:50px;
  }
</style>
</head>
<body>
<div class="container">

  <h1>🧑‍💻 AI Avatar App</h1>
  <p class="subtitle">Real-time conversational AI avatar built with Flutter — voice-driven, context-aware, and powered by a live avatar rendering engine.</p>

  <div class="badges">
    <span class="badge">Flutter</span>
    <span class="badge">Dart</span>
    <span class="badge">LiveKit</span>
    <span class="badge">HeyGen (Live Avatar)</span>
    <span class="badge">Speech-to-Text</span>
    <span class="badge">Cubit</span>
    <span class="badge">Real-time Audio Streaming</span>
  </div>

  <h2>Overview</h2>
  <p>
    This app lets a user log in, chat with an AI assistant through a text-based chatbot screen, and then jump into a
    <strong>live avatar session</strong> — a real, animated AI avatar that listens to the user's voice, understands it through
    Speech-to-Text, and replies out loud with synchronized facial and lip movement, all within a low-latency streaming pipeline.
  </p>
  <p>
    The core challenge was making the whole loop — <em>listen → understand → respond → animate</em> — feel instant, so the
    conversation feels like talking to a real person rather than waiting on an API.
  </p>

  <h2>How the App Flows</h2>
  <div class="flow">
    <div class="step">Login</div>
    <div class="arrow">→</div>
    <div class="step">Chatbot Screen</div>
    <div class="arrow">→</div>
    <div class="step">Start Live Avatar Session</div>
    <div class="arrow">→</div>
    <div class="step">Voice Conversation</div>
  </div>

  <h3>1. Login</h3>
  <p>
    Standard authentication screen that identifies the user and carries their session/context forward — so the assistant
    already "knows" who it's talking to before the conversation starts.
  </p>

  <h3>2. Chatbot Screen</h3>
  <p>
    A text-based chat interface where the user can type questions and get instant replies. This screen also builds up
    <strong>context</strong> — the topic, tone, and details of what the user is asking about — which is later passed into
    the live avatar session so the avatar continues the same conversation instead of starting from zero.
  </p>

  <h3>3. Starting a Live Avatar Session</h3>
  <p>
    When the user chooses to continue in "live" mode, the app opens a real-time session using
    <strong>LiveKit</strong> for the audio/video transport layer and a <strong>live avatar rendering integration (HeyGen)</strong>
    to generate the animated avatar in real time.
  </p>

  <h3>4. The Conversation Loop</h3>
  <p>Once the session is live, this is what happens on every turn of the conversation:</p>
  <div class="panel">
    <ol>
      <li><strong>Microphone capture</strong> — the app listens to the user's voice through a controlled mic input.</li>
      <li><strong>Speech-to-Text (STT)</strong> — the spoken audio is transcribed into text in real time.</li>
      <li><strong>Context-aware response generation</strong> — the transcribed text, combined with the conversation
        context built up since the chatbot screen, is used to generate a relevant reply (not a generic answer).</li>
      <li><strong>Avatar response streaming</strong> — the reply is sent to the live avatar engine, which speaks it back
        with synchronized lip-sync and facial animation, streamed live to the user through LiveKit.</li>
    </ol>
  </div>
  <p>
    This whole loop was tuned to keep the avatar's response lag <strong>imperceptible</strong> during live sessions —
    meaning the state updates, audio streaming, and animation sync all had to be handled without visible delay.
  </p>

  <h2>Key Technical Pieces</h2>
  <table>
    <tr><th>Piece</th><th>What it does</th></tr>
    <tr><td>Flutter</td><td>Cross-platform app shell — login, chatbot UI, and the live session screen.</td></tr>
    <tr><td>LiveKit</td><td>Handles the real-time audio streaming pipeline between the device and the avatar engine.</td></tr>
    <tr><td>Live Avatar Engine (HeyGen)</td><td>Renders the animated avatar and syncs its speech/lip movement to the generated response.</td></tr>
    <tr><td>Speech-to-Text</td><td>Converts the user's live voice input into text for processing.</td></tr>
    <tr><td>Cubit</td><td>Manages state across mic status, session status, and streaming updates without janky rebuilds.</td></tr>
    <tr><td>Context passing</td><td>Carries the conversation history from the chatbot screen into the live session, so replies stay relevant.</td></tr>
  </table>

  <h2>What I Focused On</h2>
  <ul>
    <li>Building a clean handoff between the <strong>text chatbot</strong> and the <strong>live avatar session</strong> so context isn't lost.</li>
    <li>Managing microphone permissions and audio streaming state reliably across the session lifecycle.</li>
    <li>Keeping state updates (listening / thinking / speaking) synced with Cubit so the UI always reflects what the avatar is actually doing.</li>
    <li>Minimizing perceived latency across the STT → response → avatar-animation pipeline.</li>
  </ul>

  <h2>Tech Stack</h2>
  <pre><code>Flutter · Dart · LiveKit · Live Avatar Integration (HeyGen) · Speech-to-Text · Cubit</code></pre>

  <hr>
  <div class="footer">
    Built by Toka Ahmed Elsharkawy — Flutter Developer<br>
    <a href="https://github.com/tokaahmed345">github.com/tokaahmed345</a>
  </div>

</div>
</body>
</html>
