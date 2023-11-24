import { LightningElement, api } from 'lwc';

let canvasElement, ctx; 
let attachment;
let dataURL;

export default class SignatureCapture extends LightningElement {
    canvas;
    ctx;
    drawing = false;
    convertedDataURI;


    renderedCallback() {
        // Get the canvas element and its context
        this.canvas = this.template.querySelector('canvas');
        this.ctx = this.canvas.getContext('2d');

        // Add touch event listeners
        this.canvas.addEventListener('touchstart', this.handleTouchStart.bind(this));
        this.canvas.addEventListener('touchmove', this.handleTouchMove.bind(this));
        this.canvas.addEventListener('touchend', this.handleTouchEnd.bind(this));
    }

    handleTouchStart(event) {
        event.preventDefault();

        const touch = event.touches[0];
        this.ctx.beginPath();
        this.ctx.moveTo(touch.clientX - this.canvas.getBoundingClientRect().left, touch.clientY - this.canvas.getBoundingClientRect().top);
        this.drawing = true;
    }

    handleTouchMove(event) {
        event.preventDefault();

        if (this.drawing) {
            const touch = event.touches[0];
            this.ctx.lineTo(touch.clientX - this.canvas.getBoundingClientRect().left, touch.clientY - this.canvas.getBoundingClientRect().top);
            this.ctx.stroke();
        }
    }

    handleTouchEnd(event) {
        event.preventDefault();
        this.drawing = false;
    }

    @api
    clearSignature() {
        this.ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);
    }

    @api
    handleCanvasChange() {
        const dataURL = this.canvas.toDataURL("image/png");
        // return dataURL.replace(/^data:image\/(png|jpg);base64,/, "");
        console.log('inside child component');
    //    this.ctx.globalCompositeOperation = "destination-over";
    //     this.ctx.fillStyle = "black"; //white
    //     this.ctx.fillRect(0,0,canvasElement.width, canvasElement.height); 
    //     dataURL = canvasElement.toDataURL("image/png");
        this.convertedDataURI = dataURL.replace(/^data:image\/(png|jpg);base64,/, "");
        console.log('convertedDataURI -->'+this.convertedDataURI); 

        const customEvent = new CustomEvent('canvaschange', {
            detail: this.convertedDataURI
        });
        this.dispatchEvent(customEvent);
    }
}