// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"

import ClipboardController from "./clipboard_controller"
application.register("clipboard", ClipboardController)

import HelloController from "./hello_controller"
application.register("hello", HelloController)

import LocationController from "./location_controller"
application.register("location", LocationController)

import NewsTickerController from "./news_ticker_controller"
application.register("news-ticker", NewsTickerController)

import Select2Controller from "./select2_controller"
application.register("select2", Select2Controller)

import TicketController from "./ticket_controller"
application.register("ticket", TicketController)
