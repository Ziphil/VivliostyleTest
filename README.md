<div align="center">
<h1>Vivliostyle を使ってみるテスト</h1>
</div>


## 概要
Vivliostyle で CSS 組版したい!

## 使い方
[Ruby](https://www.ruby-lang.org/ja/) と [Node.js](https://nodejs.org/ja/) をインストールし、パッケージ管理のために [Bundler](https://bundler.io/) と [npm](https://www.npmjs.com/) をさらにインストールしておいてください。
その後、このリポジトリのルートディレクトリで以下のコマンドを実行してください。
```
bundle install --gemfile=gemfile
npm install
```

以下のコマンドを実行すると、組版用の HTML ファイルと CSS ファイルが生成されます。
```
bundle exec ruby converter/main.rb
```
さらに以下のコマンドを実行すると、サーバーが起動して Vivliostyle Viewer が開き、組版結果が表示されます。
```
bundle exec ruby converter/main.rb -s
```

## にゃーん
伸び縮みするスペース (TeX の `A plus B minus C` とか XSL-FO の length-range 型とか) って CSS では対応してないんだろうか。
なんかなさそう。
地味に困る。