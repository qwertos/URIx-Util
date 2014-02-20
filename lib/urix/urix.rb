
require 'libusb'


module URIx

	class URIx

		attr_accessor :usb, :device, :handle
		attr_reader :pin_states
		
		def initialize
			@usb = LIBUSB::Context.new
			@pin_states = 0x0
		end

		def init_interface
			@device = usb.devices(:idVendor => VENDOR_ID, :idProduct => PRODUCT_ID).first
			@handle = @device.open
			
			@handle.detach_kernel_driver(HID_INTERFACE)
		end

		def set_output pin, state
			if ( @pin_states >> ( pin - 1 )).odd? && ( state == false ) or
			   ( @pin_states >> ( pin - 1 )).even? && ( state == true ) then

				mask = 0 + ( 1 << ( pin - 1 ))
				@pin_states ^= mask
			end
		end

			



	end

end

