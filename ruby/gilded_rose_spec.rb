require File.join(File.dirname(__FILE__), 'gilded_rose')

describe GildedRose do

  describe "#update_quality" do

    subject(:advance_by_1_day) { GildedRose.new(items).update_quality()}

    it "does not change the name" do
      items = [Item.new("foo", 0, 0)]
      GildedRose.new(items).update_quality()
      expect(items[0].name).to eq "foo"
    end

    context "with ordinary item" do
      let(:items) { [Item.new(name="+5 Dexterity Vest", sell_in=10, quality=20)] }
      it "decreases quality and sell_in by 1 at the end of the day" do
        advance_by_1_day
        expect(items[0].sell_in).to eq 9
        expect(items[0].quality).to eq 19
      end

      context "when sell date has passed" do
        let(:items) { [Item.new(name="+5 Dexterity Vest", sell_in=0, quality=20)] }

        it "decreases quality by 2 and sell_in by 1 at the end of the day" do
          advance_by_1_day
          expect(items[0].sell_in).to eq -1
          expect(items[0].quality).to eq 18
        end
      end

      context "when quality is 0" do
        let(:items) { [Item.new(name="+5 Dexterity Vest", sell_in=0, quality=0)] }

        it "does not decrease quality and decreases sell_in by 1 at the end of the day" do
          advance_by_1_day
          expect(items[0].sell_in).to eq -1
          expect(items[0].quality).to eq 0
        end
      end
    end

    context "with Aged Brie" do
      let(:items) { [Item.new(name="Aged Brie", sell_in=10, quality=20)] }

      it "increases quality by 1 and decreases sell_in by 1 at the end of the day" do
        advance_by_1_day
        expect(items[0].sell_in).to eq 9
        expect(items[0].quality).to eq 21
      end

      context "with quality of 50" do
        let(:items) { [Item.new(name="Aged Brie", sell_in=10, quality=50)] }

        it "does not increase quality and decreases sell_in by 1" do
          advance_by_1_day
          expect(items[0].sell_in).to eq 9
          expect(items[0].quality).to eq 50
        end
      end

      context "when sell date has passed" do
        let(:items) { [Item.new(name="Aged Brie", sell_in=0, quality=20)] }
  
        it "increases quality by 2 and decreases sell_in by 1 at the end of the day" do
          advance_by_1_day
          expect(items[0].sell_in).to eq -1
          expect(items[0].quality).to eq 22
        end
      end
    end

    context "with Sulfurus item" do
      let(:items) { [Item.new(name="Sulfuras, Hand of Ragnaros", sell_in=0, quality=80)] }

      it "doesn't change quality and sell_in" do
        advance_by_1_day
        expect(items[0].sell_in).to eq 0
        expect(items[0].quality).to eq 80
      end
    end

    context "with Backstage passes" do
      context "when sell_in date is 11" do
        let(:items) { [Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=11, quality=20)] }

        it "increases quality by 1 and decreases sell_in by 1" do
          advance_by_1_day
          expect(items[0].sell_in).to eq 10
          expect(items[0].quality).to eq 21
        end

        context "with quality of 50" do
          let(:items) { [Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=11, quality=50)] }

          it "doesn't change quality and decreases sell_in by 1" do
            advance_by_1_day
            expect(items[0].sell_in).to eq 10
            expect(items[0].quality).to eq 50
          end
        end
      end
      context "when sell_in date is 6" do
        let(:items) { [Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=6, quality=20)] }

        it "increases quality by 2 and decreases sell_in by 1" do
          advance_by_1_day
          expect(items[0].sell_in).to eq 5
          expect(items[0].quality).to eq 22
        end

        context "with quality of 49" do
          let(:items) { [Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=6, quality=49)] }

          it "increases quality to 50 and decreases sell_in by 1" do
            advance_by_1_day
            expect(items[0].sell_in).to eq 5
            expect(items[0].quality).to eq 50
          end
        end

        context "with quality of 50" do
          let(:items) { [Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=6, quality=50)] }

          it "doesn't change quality and decreases sell_in by 1" do
            advance_by_1_day
            expect(items[0].sell_in).to eq 5
            expect(items[0].quality).to eq 50
          end
        end
      end

      context "when sell_in date is 1" do
        let(:items) { [Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=1, quality=20)] }

        it "increases quality by 3 and decreases sell_in by 1" do
          advance_by_1_day
          expect(items[0].sell_in).to eq 0
          expect(items[0].quality).to eq 23
        end

        context "with quality of 48" do
          let(:items) { [Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=1, quality=48)] }

          it "increases quality to 50 and decreases sell_in by 1" do
            advance_by_1_day
            expect(items[0].sell_in).to eq 0
            expect(items[0].quality).to eq 50
          end
        end

        context "with quality of 50" do
          let(:items) { [Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=1, quality=50)] }

          it "doesn't change quality and decreases sell_in by 1" do
            advance_by_1_day
            expect(items[0].sell_in).to eq 0
            expect(items[0].quality).to eq 50
          end
        end

      end
      context "when sell_in date is 0" do
        let(:items) { [Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=0, quality=20)] }

        it "decreases quality to 0 and decreases sell_in by 1" do
          advance_by_1_day
          expect(items[0].sell_in).to eq -1
          expect(items[0].quality).to eq 0
        end
      end
    end

    context "with Conjured item" do
      let(:items) { [Item.new(name="Conjured Mana Cake", sell_in=10, quality=20)] }
      it "decreases quality by 2 and sell_in by 1 at the end of the day" do
        advance_by_1_day
        expect(items[0].sell_in).to eq 9
        expect(items[0].quality).to eq 18
      end

      context "when sell date has passed" do
        let(:items) { [Item.new(name="Conjured Mana Cake", sell_in=0, quality=20)] }

        it "decreases quality by 4 and sell_in by 1 at the end of the day" do
          advance_by_1_day
          expect(items[0].sell_in).to eq -1
          expect(items[0].quality).to eq 16
        end
      end

      context "when quality is 0" do
        let(:items) { [Item.new(name="Conjured Mana Cake", sell_in=0, quality=0)] }

        it "does not decrease quality and decreases sell_in by 1 at the end of the day" do
          advance_by_1_day
          expect(items[0].sell_in).to eq -1
          expect(items[0].quality).to eq 0
        end
      end
    end
  end

end
