#include <glog/logging.h>
#include <gflags/gflags.h>
#include "my_project_name/my_project_name.h"
 
DEFINE_string(log_message, "Sample log message", "Message to log");

void myProjectName::run(){
    LOG(INFO) << "Log message: " << FLAGS_log_message;
}
