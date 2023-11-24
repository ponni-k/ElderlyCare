import { LightningElement,api } from 'lwc';

export default class RatingCmp extends LightningElement {
  static pizzarating;
  static deliveryrating;
  static burgerrating;
  static  packagerating;
  @api name;
  rating(event) {
    if (event.target.name === "Pizza") {        
      RatingCmp.pizzarating = event.target.value;        
    }
    if (event.target.name === "Burger") {
      RatingCmp.burgerrating = event.target.value;
    }
    if (event.target.name === "Package") {
      RatingCmp.packagerating = event.target.value; 
      console.log('event.target.value : '+ RatingCmp.packagerating);
      this.dispatchEvent(new CustomEvent('messageevent', { detail:  RatingCmp.packagerating }));
    }
    if (event.target.name === "Delivery") {
      RatingCmp.deliveryrating = event.target.value;
      console.log('event.target.value : '+event.target.value)
    }
  }
@api
  getvalues() {
    this.dispatchEvent(new CustomEvent('messageevent', { detail: RatingCmp.packagerating }));
  }
}