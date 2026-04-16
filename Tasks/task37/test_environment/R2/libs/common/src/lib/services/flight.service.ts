export class FlightService {
  private worker = new Worker(new URL('./flight.worker', import.meta.url));
}
