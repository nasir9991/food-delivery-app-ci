import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class PaymentService {

  private BASE_URL = 'http://65.1.12.253:8081/api/payments/create-order';

  constructor(private http: HttpClient) {}

  /**
   * Create Razorpay order (calls Spring Boot backend)
   */
  createOrder(amount: number): Observable<any> {
    const payload = {
      amount: amount,        // INR
      currency: 'INR',
      receipt: 'ORDER_' + Date.now()
    };

    return this.http.post<any>(
      `${this.BASE_URL}/create-order`,
      payload
    );
  }

  /**
   * Verify Razorpay payment signature
   */
  verifyPayment(
    orderId: string,
    paymentId: string,
    signature: string
  ): Observable<boolean> {

    const params = new HttpParams()
      .set('razorpay_order_id', orderId)
      .set('razorpay_payment_id', paymentId)
      .set('razorpay_signature', signature);

    return this.http.post<boolean>(
      `${this.BASE_URL}/verify`,
      null,
      { params }
    );
  }
}
