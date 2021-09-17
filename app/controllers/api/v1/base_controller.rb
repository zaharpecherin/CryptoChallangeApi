module Api
  module V1
    class BaseController < ApplicationController

      def list_of_tickers
        render json: CryptoService.new.request(
          endpoint: '/currencies/ticker',
          params: { ids: params[:ids] }
        )
      end

      def crypto_info
        render json: CryptoService.new.request(
          endpoint: '/currencies/ticker',
          params: { ids: params[:ids] }
        ).specific_attributes
      end

    end
  end
end
