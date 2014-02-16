
require 'libusb'


module URIx

	class URIx

		attr_accessor :device
		
		def initialize
			usb = LIBUSB::Context.new
			@device = usb.devices(:idVendor => VENDOR_ID, :idProduct => PRODUCT_ID).first
		end

	end

end

