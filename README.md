<!DOCTYPE html>
<html lang="en">


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


</div>
</body>
</html>
