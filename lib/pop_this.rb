require 'gserver'
require 'digest/md5'
module PopThis
  class POP3Server < GServer

    def initialize(options)
      @hostname = options[:host]
      super(options[:port])
      @dir = options[:path]
    end

    class Email
      attr_reader :filename
      attr_accessor :deleted

      def self.all(dir)
        Dir.glob("#{ dir }/*").reject{|fn| fn =~ /^\./ || File.directory?(fn) }.map{|fn| Email.new(fn) }
      end

      def self.delete(email)
        File.delete(email.filename)
      end

      def initialize(filename)
        @filename = filename
        @deleted = false
      end

      def email
        @email ||= File.read(@filename)
      end

      def deleted?
        deleted
      end
    end

    def serve(io)
      @state = 'auth'
      @failed = 0
      io.print("+OK POP3 server ready\r\n")
      loop do
        if IO.select([io], nil, nil, 0.1)
          begin
            data = io.readpartial(4096)
            puts ">> #{data.chomp}"
            ok, op = process_line(data)
            puts "<< #{op.chomp}"
            io.print op
            break unless ok
          rescue Exception
          end
        end
        break if io.closed?
      end
      io.close unless io.closed?
    end

    def emails
      @emails = Email.all(@dir)
    end

    def stat
      msgs = bytes = 0
      @emails.each do |e|
        next if e.deleted?
        msgs += 1
        bytes += e.email.length
      end
      return msgs, bytes
    end

    def list(msgid = nil)
      msgid = msgid.to_i if msgid
      if msgid
        return false if msgid > @emails.length or @emails[msgid-1].deleted?
        return [ [msgid, @emails[msgid].email.length] ]
      else
        msgs = []
        @emails.each_with_index do |e,i|
          msgs << [ i + 1, e.email.length ]
        end
        msgs
      end
    end

    def retr(msgid)
      msgid = msgid.to_i
      return false if msgid > @emails.length or @emails[msgid-1].deleted?
      @emails[msgid-1].email
    end

    def dele(msgid)
      msgid = msgid.to_i
      return false if msgid > @emails.length
      @emails[msgid-1].deleted = true
    end

    def rset
      @emails.each do |e|
        e.deleted = false
      end
    end

    def quit
      @emails.each do |e|
        if e.deleted?
          Email.delete(e)
        end
      end
    end

    def process_line(line)
      line.chomp!
      case @state
      when 'auth'
        case line
        when /^QUIT$/
          return false, "+OK popthis POP3 server signing off\r\n"
        when /^USER (.+)$/
          return true, "+OK #{$1} is most welcome here\r\n"
        when /^PASS (.+)$/
          @state = 'trans'
          emails
          msgs, bytes = stat
          return true, "+OK #{msgs} messages (#{bytes} octets)\r\n"
        end
      when 'trans'
        case line
        when /^NOOP$/
          return true, "+OK\r\n"
        when /^STAT$/
          msgs, bytes = stat
          return true, "+OK #{msgs} #{bytes}\r\n"
        when /^LIST$/
          msgs, bytes = stat
          msg = "+OK #{msgs} messages (#{bytes} octets)\r\n"
          list.each do |num, bytes|
            msg += "#{num} #{bytes}\r\n"
          end
          msg += ".\r\n"
          return true, msg
        when /^LIST (\d+)$/
          msgs, bytes = stat
          num, bytes = list($1)
          if num
            return true, "+OK #{num} #{bytes}\r\n"
          else
            return true, "-ERR no such message, only #{msgs} messages in maildrop\r\n"
          end
        when /^RETR (\d+)$/
          msg = retr($1)
          if msg
            msg = "+OK #{msg.length} octets\r\n" + msg
            msg += "\r\n.\r\n"
          else
            msg = "-ERR no such message\r\n"
          end
          return true, msg
        when /^DELE (\d+)$/
          if dele($1)
            return true, "+OK message #{$1} deleted\r\n"
          else
            return true, "-ERR message #{$1} already deleted\r\n"
          end
        when /^RSET$/
          rset
          msgs, bytes = stat
          return true, "+OK maildrop has #{msgs} messages (#{bytes} octets)\r\n"
        when /^QUIT$/
          @state = 'update'
          quit
          msgs, bytes = stat
          if msgs > 0
            return false, "+OK popthis server signing off (#{msgs} messages left)\r\n"
          else
            return false, "+OK popthis server signing off (folder empty)\r\n"
          end
        when /^TOP (\d+) (\d+)$/
          lines = $2
          msg = retr($1)
          unless msg
            return true, "-ERR no such message\r\n"
          end
          cnt = nil
          final = ""
          msg.split(/\n/).each do |l|
            final += l+"\n"
            if cnt
              cnt += 1
              break if cnt > lines
            end
            if l !~ /\w/
              cnt = 0
            end
          end
          return true, "+OK\r\n"+final+".\r\n"
        when /^UIDL$/
          msgid = 0
          msg = ''
          @emails.each do |e|
            msgid += 1
            next if e.deleted?
            msg += "#{msgid} #{Digest::MD5.hexdigest(e.email)}\r\n"
          end
          return true, "+OK\r\n#{msg}.\r\n";
        end
      when 'update'
        case line
        when /^QUIT$/
          return true, "+OK popthis server signing off\r\n"
        end
      end
      return true, "-ERR unknown command\r\n"
    end

  end
end
