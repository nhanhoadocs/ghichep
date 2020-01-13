# Hướng dẫn compare cpu capabilities để kiểm tra khả năng live-migration giữa 2 compute

- Cài đặt libvirt nếu chưa có

`yum install libvirt -y`

- Start libvirt

```
systemctl start libvirtd
```

- Dump capabilities ở node compute còn lại

`virsh capabilities > virsh-caps.xml`

- Chỉnh sửa file, xóa hết các dòng và chỉ giữ lại block `<cpu> </cpu>` như ví dụ dưới đây

```
<cpu>
      <arch>x86_64</arch>
      <model>core2duo</model>
      <topology sockets='1' cores='4' threads='1'/>
      <feature name='lahf_lm'/>
      <feature name='sse4.1'/>
      <feature name='xtpr'/>
      <feature name='cx16'/>
      <feature name='tm2'/>
      <feature name='est'/>
      <feature name='vmx'/>
      <feature name='ds_cpl'/>
      <feature name='pbe'/>
      <feature name='tm'/>
      <feature name='ht'/>
      <feature name='ss'/>
      <feature name='acpi'/>
      <feature name='ds'/>
</cpu>
```

- Chuyển file này tới máy cần compare

- Tiến hành compare

`virsh cpu-compare virsh-caps.xml`

- Kết quả ra là `superset` hoặc `identical` là tương thích

<img src="https://i.imgur.com/wzQ1XHk.png">
