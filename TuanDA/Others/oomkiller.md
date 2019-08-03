

- Khi lượng RAM free trên server ít, OOM Killer sẽ được gọi từ Kernel để thực hiện việc kill process sử dụng nhiều RAM.
- Nếu không set score cho OOM (oom_score) (ví dụ /proc/<pid>/oom_score / /proc/<pid>/oom_score_adj)
- Score cao nhất là 1000 -> process sẽ liên tục bị OOM kill mặc dù sử dụng ít memory
- Score thấp nhất là -1000 -> process sẽ không bị kill mặc dù sử dụng cả 100% memory của máy chủ 

