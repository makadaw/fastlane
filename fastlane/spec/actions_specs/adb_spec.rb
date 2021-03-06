describe Fastlane do
  describe Fastlane::FastFile do
    describe "adb" do
      it "generates a valid command" do
        result = Fastlane::FastFile.new.parse("lane :test do
          adb(command: 'test', adb_path: './fastlane/README.md')
        end").runner.execute(:test)

        expect(result).to eq("./fastlane/README.md test")
      end

      it "generates a valid command for commands with multiple parts" do
        result = Fastlane::FastFile.new.parse("lane :test do
          adb(command: 'test command with multiple parts', adb_path: './fastlane/README.md')
        end").runner.execute(:test)

        expect(result).to eq("./fastlane/README.md test command with multiple parts")
      end

      it "picks up path from ANDROID_HOME environment variable" do
        stub_const('ENV', { 'ANDROID_HOME' => '/usr/local/android-sdk' })
        result = Fastlane::FastFile.new.parse("lane :test do
          adb(command: 'test')
        end").runner.execute(:test)

        expect(result).to eq("/usr/local/android-sdk/platform-tools/adb test")
      end

      it "picks up path from ANDROID_HOME environment variable and handles path that has to be made safe" do
        stub_const('ENV', { 'ANDROID_HOME' => '/usr/local/android-sdk/with space' })
        result = Fastlane::FastFile.new.parse("lane :test do
          adb(command: 'test')
        end").runner.execute(:test)

        path = "/usr/local/android-sdk/with space/platform-tools/adb".shellescape
        expect(result).to eq("#{path} test")
      end

      it "picks up path from ANDROID_SDK_ROOT environment variable" do
        stub_const('ENV', { 'ANDROID_SDK_ROOT' => '/usr/local/android-sdk' })
        result = Fastlane::FastFile.new.parse("lane :test do
          adb(command: 'test')
        end").runner.execute(:test)

        expect(result).to eq("/usr/local/android-sdk/platform-tools/adb test")
      end

      it "picks up path from ANDROID_SDK environment variable" do
        stub_const('ENV', { 'ANDROID_SDK' => '/usr/local/android-sdk' })
        result = Fastlane::FastFile.new.parse("lane :test do
          adb(command: 'test')
        end").runner.execute(:test)

        expect(result).to eq("/usr/local/android-sdk/platform-tools/adb test")
      end
    end
  end
end
