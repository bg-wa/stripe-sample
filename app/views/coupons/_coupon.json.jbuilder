json.extract! coupon, :id, :duration, :name, :percent_off, :created_at, :updated_at
json.url coupon_url(coupon, format: :json)
