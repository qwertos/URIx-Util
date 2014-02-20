
require 'libusb'


module URIx

	class URIx

		attr_accessor :usb, :device, :handle
		attr_reader :pin_states, :pin_modes
		
		def initialize
			@usb = LIBUSB::Context.new
			@pin_states = 0x0
			@pin_modes = 0x0

			set_pin_mode( PTT_PIN, :output )
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

		def set_pin_mode pin, mode
			if ( @pin_modes >> ( pin - 1 )).odd? && ( mode == :input ) or
			   ( @pin_modes >> ( pin - 1 )).even? && ( mode == :output ) then

				mask = 0 + ( 1 << ( pin - 1 ))
				@pin_modes ^= mask
			end
		end
			
	end

end

