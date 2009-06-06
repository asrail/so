require 'Qt4'
$KCODE='utf8'

class Qt::Action
  ##XXXasrail
  attr_accessor :name
end

class Window < Qt::MainWindow
  def initialize(model, parent = nil)
    super()
    self.windowTitle = tr("SystemTap logs")
    aux_actions = {}
    @actions = {}

    @mview = Qt::VBoxLayout.new()
    
    row = Qt::HBoxLayout.new
    model.headers.each { |header|
      row.addWidget(Qt::Label.new(header))
    }
    @mview.addLayout(row)

    
    row2 = Qt::HBoxLayout.new
    row2.addWidget(Qt::Label.new("uno"))
    row2.addWidget(Qt::Label.new("dos"))
    row2.addWidget(Qt::Label.new("tres"))    
    @mview.addLayout(row2)
    
    vp = Qt::VBoxLayout.new()
    vp.addLayout(@mview)
    toolbar = Qt::ToolBar.new(self)

    aux_actions[:commands] = [
       [:stop, "images/32/process-stop.png", "&Parar", "Ctrl+p", "Interrompe a execução"], 
       [:play, "images/32/media-playback-start.png", "E&xecutar", "Ctrl+r", "Inicia a execução"] 
    ]

    aux_actions[:file] = [
       [:open_file, "images/32/document-open.png", "&Abrir",
        "Ctrl+o", "Carregar um script de um arquivo"],
       [:save_machine, "images/32/document-save.png", "&Salvar",
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
    central = Qt::Widget.new(self)
    central.setLayout(vp)
    setCentralWidget(central)
    Qt::MetaObject.connectSlotsByName(self)
  end
end

class LogModel < Qt::Object
  attr_accessor :arr, :headers
  signals 'row_added(QVector<QString>)'
  
  def initialize(parent = nil)
    super(parent)
    @arr = [["abc", "ddd", "alskdjalsdkjaksldja asdjk alsdj asld asldj aslja sdj adlajsk alksjakdjd"],
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
    emit row_added()
  end
  
  def headerData(section, orientation, role = Qt::DisplayRole)
    @headers[section]
  end
end


def main()
  app = Qt::Application.new(ARGV)
  Qt::TextCodec::setCodecForTr(Qt::TextCodec::codecForName("utf8"))

  #mw = Window.new()
  #mw.show()
  
  log_model = LogModel.new
  view = Window.new(log_model)
  view.show
  
  app.exec
end

if __FILE__ == $0
  main()
end
