require_relative('../lib/focus_point.rb')

describe FocusPoint do
  let(:params) { { img_width: 1000, img_height: 1000, frame_height: 200, frame_width: 300 } }
  let(:item) { FocusPoint.new(params) }

  describe '#initialize' do
    it 'checks frame params and resize it if too big' do
      prms = { img_width: 1000, img_height: 1000, frame_height: 10_000, frame_width: 10_000 }
      instance = FocusPoint.new(prms)
      expect(instance.frame_height).to eq 1000
      expect(instance.frame_width).to eq 1000

      prms = { img_width: 1000, img_height: 1000, frame_height: 1000, frame_width: 1200 }
      instance = FocusPoint.new(prms)
      expect(instance.frame_height).to eq 833
      expect(instance.frame_width).to eq 1000

      prms = { img_width: 1000, img_height: 1000, frame_height: 1400, frame_width: 1200 }
      instance = FocusPoint.new(prms)
      expect(instance.frame_height).to eq 1000
      expect(instance.frame_width).to eq 857
    end
  end

  describe '#coords_for_crop_around' do
    it 'raise exception if point coordinates is not correct' do
      expect { item.coords_for_crop_around(x: -500, y: 8000) }.to raise_error
    end

    it 'makes crop frame bigger if possible' do
      prms = { img_width: 1000, img_height: 1000, frame_height: 100, frame_width: 100 }
      instance = FocusPoint.new(prms)
      expect(instance.coords_for_crop_around(x: 500, y: 500)).to eq(x: 0, y: 0, width: 1000, height: 1000)

      prms = { img_width: 1000, img_height: 1000, frame_height: 50, frame_width: 100 }
      instance = FocusPoint.new(prms)
      expect(instance.coords_for_crop_around(x: 500, y: 500)).to eq(x: 0, y: 250, width: 1000, height: 500)

      prms = { img_width: 1000, img_height: 1000, frame_height: 100, frame_width: 50 }
      instance = FocusPoint.new(prms)
      expect(instance.coords_for_crop_around(x: 500, y: 500)).to eq(x: 250, y: 0, width: 500, height: 1000)

      prms = { img_width: 500, img_height: 1000, frame_height: 100, frame_width: 100 }
      instance = FocusPoint.new(prms)
      expect(instance.coords_for_crop_around(x: 250, y: 500)).to eq(x: 0, y: 250, width: 500, height: 500)

      prms = { img_width: 500, img_height: 1000, frame_height: 100, frame_width: 50 }
      instance = FocusPoint.new(prms)
      expect(instance.coords_for_crop_around(x: 250, y: 500)).to eq(x: 0, y: 0, width: 500, height: 1000)

      prms = { img_width: 500, img_height: 1000, frame_height: 50, frame_width: 100 }
      instance = FocusPoint.new(prms)
      expect(instance.coords_for_crop_around(x: 250, y: 500)).to eq(x: 0, y: 375, width: 500, height: 250)

      prms = { img_width: 1500, img_height: 1000, frame_height: 100, frame_width: 1000 }
      instance = FocusPoint.new(prms)
      expect(instance.coords_for_crop_around(x: 750, y: 500)).to eq(x: 0, y: 425, width: 1500, height: 150)

      prms = { img_width: 1500, img_height: 1000, frame_height: 500, frame_width: 250 }
      instance = FocusPoint.new(prms)
      expect(instance.coords_for_crop_around(x: 750, y: 500)).to eq(x: 500, y: 0, width: 500, height: 1000)

      prms = { img_width: 1500, img_height: 1000, frame_height: 250, frame_width: 250 }
      instance = FocusPoint.new(prms)
      expect(instance.coords_for_crop_around(x: 750, y: 500)).to eq(x: 250, y: 0, width: 1000, height: 1000)
    end

    it 'calls draw_frame method which returns frame border`s values' do
      expect(item).to receive(:draw_frame).and_call_original
      expect(item.coords_for_crop_around(x: 500, y: 500)).to eq(x: 0, y: 167, width: 1000, height: 666)
    end

    it 'will move frame if it crosses image`s borders' do
      expect(item.coords_for_crop_around(x: 0, y: 0)).to eq(x: 0, y: 0, width: 300, height: 200)
      expect(item.coords_for_crop_around(x: 50, y: 500)).to eq(x: 0, y: 400, width: 300, height: 200)
      expect(item.coords_for_crop_around(x: 1000, y: 1000)).to eq(x: 700, y: 800, width: 300, height: 200)
      expect(item.coords_for_crop_around(x: 950, y: 950)).to eq(x: 700, y: 800, width: 300, height: 200)
      expect(item.coords_for_crop_around(x: 900, y: 500)).to eq(x: 700, y: 400, width: 300, height: 200)
    end
  end
end
