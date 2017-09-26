require 'sinatra'
require 'erb'

set :bind, '0.0.0.0'

get '/' do
  '<head>
    <title>App</title>
</head>
<body>

<meta http-equiv="refresh" content="0; url=/init" />


</body>'
end

get '/init' do
	erb :init
end


