#include <glog/logging.h>
#include <gflags/gflags.h>
#include "my_project_name/my_project_name.h"


int main(int argc, char* argv[]) {
    // Initialise glog and gflags
    google::InitGoogleLogging(argv[0]);
    google::ParseCommandLineFlags(&argc, &argv, true);

    if(FLAGS_log_dir.empty()){
        FLAGS_alsologtostderr=true;
        LOG(ERROR) << "log_dir not set, logging to stderr!!";
        
    }

    VLOG(2) << "Initialised glog and gflags with log directory set to : " << FLAGS_log_dir;  

    

    myProjectName::run();
 
    VLOG(2) << "Shutting down glog";
    google::ShutdownGoogleLogging();
}