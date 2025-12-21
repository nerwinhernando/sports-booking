# class Api::V1::VenuesController < ApplicationController
# end
module Api
  module V1
    class VenuesController < BaseController
      skip_before_action :authenticate_api_user!, only: [:index, :show]

      def index
        @venues = Venue.active.includes(:courts)

        # Apply filters
        @venues = @venues.by_province(params[:province]) if params[:province].present?
        @venues = @venues.by_city(params[:city]) if params[:city].present?

        # Filter by court features
        if params[:court_type].present?
          @venues = @venues.joins(:courts).where(courts: { court_type: params[:court_type] }).distinct
        end

        @venues = @venues.page(params[:page]).per(params[:per_page] || 20)

        render_success({
          venues: @venues.map { |v| venue_json(v) },
          meta: pagination_meta(@venues)
        })
      end

      def show
        @venue = Venue.find(params[:id])
        @courts = @venue.courts.active

        render_success({
          venue: venue_detail_json(@venue),
          courts: @courts.map { |c| court_json(c) }
        })
      end

      def schedules
        @venue = Venue.find(params[:id])
        date = params[:date]&.to_date || Date.current

        @schedules = @venue.available_schedules(date)

        render_success({
          date: date,
          schedules: @schedules.map { |s| schedule_json(s) }
        })
      end

      private

      def venue_json(venue)
        {
          id: venue.id,
          name: venue.name,
          address: venue.address,
          city: venue.city,
          province: venue.province,
          phone: venue.phone,
          courts_count: venue.courts.active.count,
          latitude: venue.latitude,
          longitude: venue.longitude
        }
      end

      def venue_detail_json(venue)
        venue_json(venue).merge({
          full_address: venue.full_address,
          barangay: venue.barangay,
          municipality: venue.municipality
        })
      end

      def court_json(court)
        {
          id: court.id,
          court_number: court.court_number,
          court_type: court.court_type,
          floor_type: court.floor_type,
          has_air_conditioning: court.has_air_conditioning,
          features: court.features_list
        }
      end

      def schedule_json(schedule)
        {
          id: schedule.id,
          court_id: schedule.court_id,
          court_number: schedule.court.court_number,
          date: schedule.schedule_date,
          start_time: schedule.start_time.strftime('%H:%M'),
          end_time: schedule.end_time.strftime('%H:%M'),
          time_slot: schedule.time_slot_label,
          price_cents: schedule.price_cents,
          price_php: schedule.price_php,
          is_peak_hour: schedule.is_peak_hour,
          status: schedule.status
        }
      end

      def pagination_meta(collection)
        {
          current_page: collection.current_page,
          next_page: collection.next_page,
          prev_page: collection.prev_page,
          total_pages: collection.total_pages,
          total_count: collection.total_count
        }
      end
    end
  end
end
