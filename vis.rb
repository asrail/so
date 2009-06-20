require 'pp'
require 'Qt4'
$KCODE='utf8'

class Qt::Action
  ##XXXasrail
  attr_accessor :name
end

class Window < Qt::MainWindow
  attr_accessor :script
  slots 'add_row(QString)', :play, :open_1, :open_2, :open_3, :open
  
  def initialize(model, parent = nil)
    super(parent)
    self.windowTitle = tr("SystemTap logs")
    aux_actions = {}
    @actions = {}
    @script = nil
    @scroll = Qt::ScrollArea.new()
    @scroll.setWidgetResizable(true)
    @central = Qt::Widget.new(@scroll)
    @model = model
    
    toolbar = Qt::ToolBar.new(self)

    connect(model, SIGNAL('row_added(QString)'), self, SLOT('add_row(QString)'))
    
    aux_actions[:commands] = [
       [:stop, "images/32/process-stop.png", "&Parar", "Ctrl+p", "Interrompe a execução"], 
       [:play, "images/32/media-playback-start.png", "E&xecutar", "Ctrl+r", "Inicia a execução"] 
    ]

    aux_actions[:file] = [
       [:open, "images/32/document-open.png", "&Abrir",
        "Ctrl+o", "Carrega um script de um arquivo"],
       [:open_1, "images/32/document-open.png", "Script &1",
        "Ctrl+1", "Carrega o script do exercício 1"],
       [:open_2, "images/32/document-open.png", "Script &2",
        "Ctrl+2", "Carrega o script do exercício 2"],
       [:open_3, "images/32/document-open.png", "Script &3",
        "Ctrl+3", "Carrega o script do exercício 3"],

       [:save, "images/32/document-save.png", "&Salvar",
        "Ctrl+s", "Salva a saída para um arquivo"],
       [:close, "images/32/system-log-out.png", "Sai&r",
        "Ctrl+q", "Sai do programa"]
    ] #XXXasrail: close -> quit

     aux_actions[:about] = [
        [:about, nil, "&Sobre",
        "F1", "SystemTap logs..."]
     ]

    aux_actions.each {|group, actions|      
      @actions[group] = actions.map {|but|
        act = Qt::Action.new(self)
        act.text = but[2]
        act.icon = Qt::Icon.new(but[1]) if but[1]
        act.shortcut = but[3] if but[3]
        act.statusTip = but[4]
        act.name = but[0]
        connect(act, SIGNAL(:triggered), self, SLOT(but[0]))
        act
      }
    }

    @menubar = Qt::MenuBar.new(self)
    @menubar.objectName = "menubar"

    aux_menus = [[:file, "&Arquivo"],
             [:commands, "&Comandos"],
             [:about, "Aj&uda"]]

    @menus = aux_menus.map {|group, name|
      menu = Qt::Menu.new(@menubar)
      menu.objectName = "menu" + group.to_s
      menu.title = name
      @menubar.addAction(menu.menuAction())
      @actions[group].each {|act|
        menu.addAction(act)
      }
      menu
    }

    @actions[:commands].each {|act|
      toolbar.addAction(act)
    }
    setMenuBar(@menubar)
    toolbar.tool_button_style = Qt::ToolButtonTextBesideIcon ##XXXasrail: preferencia...
    addToolBar(toolbar)

    
    @scroll.setWidget(@central)
    @scroll.setMinimumWidth(760)
    @scroll.setSizePolicy(Qt::SizePolicy::MinimumExpanding, Qt::SizePolicy::MinimumExpanding)
    setCentralWidget(@scroll)
    Qt::MetaObject.connectSlotsByName(self)
  end

    
  def play
    #XXXasrail: dummy test
    # Essa função deve executar o(s) script(s)
      @model.insertRow(["asd", "kjkjkj", "asd, asda, as kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkklmnasdaskdnasdjanskdjanskdjansdjkasndjkansdjkaskdjnasjkdnaksjndkajsndkajsndaks asdkajs klasdalksd laksd jakljsdakljsdakljsdklasj aklsdalskd askld askld askld asdkasd alskd asdkl asdla sdaklsd alskd aslkd aslkdjaskdalsdjaskl daslkd askldasjdaksdj asldkajsd alsdlkasj daklsd alsdalsd alsd asdl asdasjdlaskd aslkd asldkajsdklasdlkasdasd, asda, as kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkl asdkajs klasdalksd laksd jakljsdakljsdakljsdklasj aklsdalskd askld askld askld asdkasd alskd asdkl asdla sdaklsd alskd aslkd aslkdjaskdalsdjaskl daslkd askldasjdaksdj asldkajsd alsdlkasj daklsd alsdalsd alsd asdl asdasjdlaskd aslkd asldkajsdklasdlkasdasd, asda, as kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkl asdkajs klasdalksd laksd jakljsdakljsdakljsdklasj aklsdalskd askld askld askld asdkasd alskd asdkl asdla sdaklsd alskd aslkd aslkdjaskdalsdjaskl daslkd askldasjdaksdj asldkajsd alsdlkasj daklsd alsdalsd alsd asdl asdasjdlaskd aslkd asldkajsdklasdlkasdasd, asda, as kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkl asdkajs klasdalksd laksd jakljsdakljsdakljsdklasj aklsdalskd askld askld askld asdkasd alskd asdkl asdla sdaklsd alskd aslkd aslkdjaskdalsdjaskl daslkd askldasjdaksdj asldkajsd alsdlkasj daklsd alsdalsd alsd asdl asdasjdlaskd aslkd asldkajsdklasdlkasdasd, asda, as kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkl asdkajs klasdalksd laksd jakljsdakljsdakljsdklasj aklsdalskd askld askld askld asdkasd alskd asdkl asdla sdaklsd alskd aslkd aslkdjaskdalsdjaskl daslkd askldasjdaksdj asldkajsd alsdlkasj daklsd alsdalsd alsd asdl asdasjdlaskd aslkd asldkajsdklasdlkasdasd, asda, as kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkl asdkajs klasdalksd laksd jakljsdakljsdakljsdklasj aklsdalskd askld askld askld asdkasd alskd asdkl asdla sdaklsd alskd aslkd aslkdjaskdalsdjaskl daslkd askldasjdaksdj asldkajsd alsdlkasj daklsd alsdalsd alsd asdl asdasjdlaskd aslkd asldkajsdklasdlkasdasd, asda, as kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkl asdkajs klasdalksd laksd jakljsdakljsdakljsdklasj aklsdalskd askld askld askld asdkasd alskd asdkl asdla sdaklsd alskd aslkd aslkdjaskdalsdjaskl daslkd askldasjdaksdj asldkajsd alsdlkasj daklsd alsdalsd alsd asdl asdasjdlaskd aslkd asldkajsdklasdlkasdasd, asda, as kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkl asdkajs klasdalksd laksd jakljsdakljsdakljsdklasj aklsdalskd askld askld askld asdkasd alskd asdkl asdla sdaklsd alskd aslkd aslkdjaskdalsdjaskl daslkd askldasjdaksdj asldkajsd alsdlkasj daklsd alsdalsd alsd asdl asdasjdlaskd aslkd asldkajsdklasdlkasdasd, asda, as kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkl asdkajs klasdalksd laksd jakljsdakljsdakljsdklasj aklsdalskd askld askld askld asdkasd alskd asdkl asdla sdaklsd alskd aslkd aslkdjaskdalsdjaskl daslkd askldasjdaksdj asldkajsd alsdlkasj daklsd alsdalsd alsd asdl asdasjdlaskd aslkd asldkajsdklasdlkasdasd, asda, as kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkl asdkajs klasdalksd laksd jakljsdakljsdakljsdklasj aklsdalskd askld askld askld asdkasd alskd asdkl asdla sdaklsd alskd aslkd aslkdjaskdalsdjaskl daslkd askldasjdaksdj asldkajsd alsdlkasj daklsd alsdalsd alsd asdl asdasjdlaskd aslkd asldkajsdklasdlkasdasd, asda, as kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkl asdkajs klasdalksd laksd jakljsdakljsdakljsdklasj aklsdalskd askld askld askld asdkasd alskd asdkl asdla sdaklsd alskd aslkd aslkdjaskdalsdjaskl daslkd askldasjdaksdj asldkajsd alsdlkasj daklsd alsdalsd alsd asdl asdasjdlaskd aslkd asldkajsdklasdlkasd
asd, asda, as kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkl asdkajs klasdalksd laksd jakljsdakljsdakljsdklasj aklsdalskd askld askld askld asdkasd alskd asdkl asdla sdaklsd alskd aslkd aslkdjaskdalsdjaskl daslkd askldasjdaksdj asldkajsd alsdlkasj daklsd alsdalsd alsd asdl asdasjdlaskd aslkd asldkajsdklasdlkasdasd, asda, as kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkl asdkajs klasdalksd laksd jakljsdakljsdakljsdklasj aklsdalskd askld askld askld asdkasd alskd asdkl asdla sdaklsd alskd aslkd aslkdjaskdalsdjaskl daslkd askldasjdaksdj asldkajsd alsdlkasj daklsd alsdalsd alsd asdl asdasjdlaskd aslkd asldkajsdklasdlkasd"])
  end
  
  def build_grid
    @grid = Qt::GridLayout.new(@central) { |g| g.setSizeConstraint(Qt::Layout::SetMinimumSize)}
    
    @model.headers.each_with_index { |header, i|
      @grid.addWidget(Qt::Label.new(header) { |l|
                        l.setFrameStyle(Qt::Frame::Panel | Qt::Frame::Raised)
                        l.setLineWidth(2)
                        # Deve ser configurável
                        l.setMinimumWidth(180)
                        l.setMinimumHeight(30) }, 0, i)
      @grid.setRowMinimumHeight(0, 40)
    }
    
    @model.arr.each { |row|
      add_row(row)
    }
  end
  
  def add_row(row)
    if row.kind_of?String
      row = row.split(/\\\*\//)
    end
    i = @grid.rowCount
    @grid.setRowMinimumHeight(i, 40)
    row.each_with_index { |col, j|
      @grid.addWidget(Qt::Label.new(col) { |l|
        l.wordWrap = true
        l.setFrameStyle(Qt::Frame::Panel | Qt::Frame::Plain)
        l.setAlignment(Qt::AlignTop | Qt::AlignLeft)
        l.setSizePolicy(Qt::SizePolicy::MinimumExpanding, Qt::SizePolicy::MinimumExpanding)
      }, i, j)
    }
  end
  
  def open_helper(file)
    #load_script
    build_grid
  end
  
  def open
    open_helper(Qt::FileDialog.getOpenFileName(self, "Abrir script",
                                   "", "Scripts (*stp)"))
  end
    
  def open_1
    open_helper("./ex1/ex1.stp")
  end

  def open_2
    open_helper("./ex2/ex2.stp")
  end

  def open_3
    open_helper("./ex3/ex3.stp")
  end
  
  def define_script(script)
    @script = script
  end
  
end

class LogModel < Qt::Object
  attr_accessor :arr, :headers
  signals 'row_added(QString)'
  
  def initialize(parent = nil)
    super(parent)
    @arr = [["abc", "ddd", "alskdjalsdkjaksldja asdjk alsdj asld asldj aslja sdj adlajsk alksjakdjd"],
            ["abc", "ddd", "alskdjalsdkjaksldja asdjk alsdj asld asldj aslja sdj adlajsk alksjakdjd"],
            ["abc", "ddd", "alskdjalsdkjaksldja asdjk alsdj asld asldj aslja sdj adlajsk alksjakdjd"],
            ["abc", "ddd", "alskdjalsdkjaksldja asdjk alsdj asld asldj aslja sdj adlajsk alksjakdjd"],
            ["abc", "ddd", "alskdjalsdkjaksldja asdjk alsdj asld asldj aslja sdj adlajsk alksjakdjd alskdjalsdkjaksldja asdjk alsdj asld asldj aslja sdj adlajsk alksjakdjdalskdjalsdkjaksldja asdjk alsdj asld asldj aslja sdj adlajsk alksjakdjdalskdjalsdkjaksldja asdjk alsdj asld asldj aslja sdj adlajsk alksjakdjdalskdjalsdkjaksldja asdjk alsdj asld asldj aslja sdj adlajsk alksjakdjdalskdjalsdkjaksldja asdjk alsdj asld asldj aslja sdj adlajsk alksjakdjdalskdjalsdkjaksldja asdjk alsdj asld asldj aslja sdj adlajsk alksjakdjdalskdjalsdkjaksldja asdjk alsdj asld asldj aslja sdj adlajsk alksjakdjdalskdjalsdkjaksldja asdjk alsdj asld asldj aslja sdj adlajsk alksjakdjdalskdjalsdkjaksldja asdjk alsdj asld asldj aslja sdj adlajsk alksjakdjdalskdjalsdkjaksldja asdjk alsdj asld asldj aslja sdj adlajsk alksjakdjdalskdjalsdkjaksldja asdjk alsdj asld asldj aslja sdj adlajsk alksjakdjdalskdjalsdkjaksldja asdjk alsdj asld asldj aslja sdj adlajsk alksjakdjd
alskdjalsdkjaksldja asdjk alsdj asld asldj aslja sdj adlajsk alksjakdjdalskdjalsdkjaksldja asdjk alsdj asld asldj aslja sdj adlajsk alksjakdjdalskdjalsdkjaksldja asdjk alsdj asld asldj aslja sdj adlajsk alksjakdjdalskdjalsdkjaksldja asdjk alsdj asld asldj aslja sdj adlajsk alksjakdjdalskdjalsdkjaksldja asdjk alsdj asld asldj aslja sdj adlajsk alksjakdjd
alskdjalsdkjaksldja asdjk alsdj asld asldj aslja sdj adlajsk alksjakdjdalskdjalsdkjaksldja asdjk alsdj asld asldj aslja sdj adlajsk alksjakdjdalskdjalsdkjaksldja asdjk alsdj asld asldj aslja sdj adlajsk alksjakdjd
alskdjalsdkjaksldja asdjk alsdj asld asldj aslja sdj adlajsk alksjakdjdalskdjalsdkjaksldja asdjk alsdj asld asldj aslja sdj adlajsk alksjakdjd
"],
            ["abc", "ddd", "alskdjalsdkjaksldja asdjk alsdj asld asldj aslja sdj adlajsk alksjakdjd"],
            ["xyz", "uuu", "oioiqwueioquwe qweuq weiqu woiquwe qoeu zcmzxn caaaaaaaaaaaaaaaaaamxnc zxczxcz zmxcnzxcn"]]
    @headers = ["baa", "bee", "bii"]
  end
  
  def rowCount(row = 0, col = 0)
    arr.size
  end
  
  def columnCount(row = 0, col = 0)
    arr[row].size unless arr[row].nil?
  end
  
  def data(row = 0, col = 0, role = Qt::DisplayRole)
    tmp = arr[row]
    tmp = tmp[column] unless tmp.nil?
    return Qt::Variant.new if tmp.nil?
    return tmp
  end
  
  def insertRow(data)
    arr.push(data)
    emit row_added(data.join('\*/'))
  end
  
  def headerData(section, orientation, role = Qt::DisplayRole)
    @headers[section]
  end
end


def main()
  app = Qt::Application.new(ARGV)
  Qt::TextCodec::setCodecForTr(Qt::TextCodec::codecForName("utf8"))
  
  log_model = LogModel.new
  mw = Window.new(log_model)
  mw.show

  app.exec
end

if __FILE__ == $0
  main()
end

