
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

		def claim_interface
			@device = usb.devices(:idVendor => VENDOR_ID, :idProduct => PRODUCT_ID).first
			@handle = @device.open
			
			@handle.detach_kernel_driver(HID_INTERFACE)
			@handle.claim_interface( HID_INTERFACE )
		end

		def set_output pin, state
			state = false if state == :low
			state = true  if state == :high

			if ( @pin_states >> ( pin - 1 )).odd? && ( state == false ) or
			   ( @pin_states >> ( pin - 1 )).even? && ( state == true ) then

				mask = 0 + ( 1 << ( pin - 1 ))
				@pin_states ^= mask
			end
			
			write_output
		end

		def set_pin_mode pin, mode
			if ( @pin_modes >> ( pin - 1 )).odd? && ( mode == :input ) or
			   ( @pin_modes >> ( pin - 1 )).even? && ( mode == :output ) then

				mask = 0 + ( 1 << ( pin - 1 ))
				@pin_modes ^= mask
			end

			write_output
		end

		def set_ptt state
			set_output PTT_PIN, state
		end
		
		private
		def write_output
			type  = LIBUSB::ENDPOINT_OUT
			type += LIBUSB::REQUEST_TYPE_CLASS
			type += LIBUSB::RECIPIENT_INTERFACE

			request = HID_REPORT_SET

			value = 0 + ( HID_RT_OUTPUT << 8 )

			index = HID_INTERFACE

			dout  = 0.chr
			dout += @pin_states.chr
			dout += @pin_modes.chr
			dout += 0.chr

			@handle.control_transfer(
				:bmRequestType => type,
				:bRequest => request,
				:wValue => value,
				:wIndex => index,
				:dataOut => dout
			)
		end

	end
end

