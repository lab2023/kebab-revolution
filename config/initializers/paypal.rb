PayPal::Recurring.configure do |config|

  if Rails.env == 'production'
    config.sandbox   = false
    config.username  = "info_api2.companyname.com"
    config.password  = "PASSWORD"
    config.signature = "SINGNATURE"
  else
    config.sandbox   = true
    config.username  = "seller_1325467709_biz_api1.lab2023.com"
    config.password  = "PASSWORD"
    config.signature = "SINGNATURE"
  end
end