require "yaml"
configuration = YAML.load_file "configuration.yaml"



ENV['VAGRANT_DEFAULT_PROVIDER'] = 'libvirt'

# Variables
VAGRANT_API_VERSION = configuration['vagrant_api_version']
host_os = configuration['host_os']
default_user = configuration['default_user']
default_user_password = configuration['default_user_password']
servers = configuration['servers']
resize_fs_script = configuration['shell_scripts']['resize_fs_ubuntu_lvm']['script_path']
add_user_script = configuration['shell_scripts']['add_default_user']['script_path']
change_dns_script = configuration['shell_scripts']['change_dns']['script_path']
copy_ssh_pub_script = configuration['shell_scripts']['copy_ssh_pub']['script_path']
ssh_pub_key = configuration['ssh_key']

Vagrant.configure(VAGRANT_API_VERSION) do |config|
  servers.each do|type, machines|
    machines.each do |name, specs|
      puts "SERVER: #{name}"
      config.vm.define name do |machine|
        puts "CONF: #{name} #{host_os} #{specs}"
        machine.vm.box = host_os
        machine.vm.hostname = name
        machine.vm.network "private_network", ip: specs['ip']
        machine.vm.provider "libvirt" do |virt|
          virt.memory = specs['memory']
          virt.cpus = specs['cpus']
          if specs['root_disk_size']
            virt.machine_virtual_size = specs['root_disk_size']
          end
        
        end

        if specs['root_disk_size']
          machine.vm.provision "shell", path: resize_fs_script, name: "Resize filesystem for match new disk size"
        end

        machine.vm.provision "shell", path: add_user_script, name: "Add default user on system", env: { "USER_NAME" => default_user, "USER_PW" => default_user_password }

        machine.vm.provision "shell", path: change_dns_script, name: "Change default dns with script to avoid slow DNS on qemu" 


        if ssh_pub_key['copy_ssh_pub_key']
          machine.vm.provision "file", source: "#{ssh_pub_key['pub_key_path']}#{ssh_pub_key['pub_key_name']}", destination: "#{ssh_pub_key['pub_key_destination']}#{ssh_pub_key['pub_key_name']}"

          machine.vm.provision "shell", path: copy_ssh_pub_script, name: "Copy pub key on folder in server to a given user .ssh folder", env: {"USER_NAME" => default_user, "SSH_PUB_FILE_ORIGIN_PATH" => ssh_pub_key['pub_key_destination'], "SSH_PUB_FILE_NAME" => ssh_pub_key['pub_key_name']}
        end

      end
    end
  end
    
end

