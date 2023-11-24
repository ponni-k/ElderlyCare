import { LightningElement,track } from 'lwc';

export default class VoiceInput extends LightningElement {
    @track text = '';
    @track isListening = false;
    recognition = null;

    connectedCallback() {
        this.initializeRecognition();
    }

    initializeRecognition() {
        if ('webkitSpeechRecognition' in window) {
            this.recognition = new webkitSpeechRecognition();
            this.recognition.continuous = true;
            this.recognition.interimResults = true;
            this.recognition.lang = 'en-US';

            this.recognition.onstart = () => {
                this.isListening = true;
                console.log('Voice Text: '+this.isListening);
            };

            this.recognition.onresult = (event) => {
                let interimTranscript = '';
                for (let i = event.resultIndex; i < event.results.length; ++i) {
                    if (event.results[i].isFinal) {
                        this.text += event.results[i][0].transcript;
                    } else {
                        interimTranscript += event.results[i][0].transcript;
                    }
                }
                this.text = interimTranscript;
            };

            this.recognition.onend = () => {
                this.isListening = false;
            };

            this.recognition.onerror = (event) => {
                console.error('Speech recognition error: ', event.error);
            };
        }
    }

    handleInputChange(event) {
        this.text = event.target.value;
    }

    startVoiceInput() {
        if (this.recognition) {
            if (this.isListening) {
                this.recognition.stop();
            } else {
                try {
                    this.recognition.start();
                } catch (error) {
                    console.error('Speech  error:', error.message);
                    if (error.message === 'not-allowed') {
                        // Provide a user-friendly message about microphone permission
                        alert('Please allow microphone access to use voice input.');
                    }
                }
            }
        } else {
            console.error('Web Speech API is not supported in this browser.');
        }
    }
    
}