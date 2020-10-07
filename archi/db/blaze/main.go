package main

import (
	"log"
	"path"

	"github.com/lni/dragonboat/v3/config"
	"github.com/mkawserm/flamed/pkg/conf"
	"github.com/mkawserm/flamed/pkg/flamed"
	"github.com/mkawserm/flamed/pkg/variable"
)

const (
	storagePath     = "/var/blaze"
	raftStoragePath = storagePath + "/raft"
	raftAddress     = "localhost:8111"
	rttMillisecond  = 111
)

const (
	clusterID   = uint64(1)
	clusterName = "cluster-1"
)

func main() {
	f := flamed.NewFlamed()

	nodeConfiguration := getNodeConfiguration(raftStoragePath)
	nodeConfiguration.NodeConfigurationInput.LogDB = config.GetTinyMemLogDBConfig()

	if err := f.ConfigureNode(nodeConfiguration); err != nil {
		log.Fatalf("failed to configure node: %v\n", err)
	}
}

func getNodeConfiguration(raftStoragePath string) *conf.NodeConfiguration {
	return &conf.NodeConfiguration{
		NodeConfigurationInput: conf.NodeConfigurationInput{
			NodeHostDir:    raftStoragePath,
			WALDir:         raftStoragePath,
			RaftAddress:    raftAddress,
			RTTMillisecond: rttMillisecond,
			// ListenAddress:  "",
			// DeploymentID:                  viper.GetUint64(constant.DeploymentID),
			// MutualTLS:                     viper.GetBool(constant.MutualTLS),
			// CAFile:                        viper.GetString(constant.CAFile),
			// CertFile:                      viper.GetString(constant.CertFile),
			// KeyFile:                       viper.GetString(constant.KeyFile),
			// MaxSendQueueSize:              viper.GetUint64(constant.MaxSendQueueSize),
			// MaxReceiveQueueSize:           viper.GetUint64(constant.MaxReceiveQueueSize),
			// EnableMetrics:                 viper.GetBool(constant.EnableMetrics),
			// MaxSnapshotSendBytesPerSecond: viper.GetUint64(constant.MaxSnapshotSendBytesPerSecond),
			// MaxSnapshotRecvBytesPerSecond: viper.GetUint64(constant.MaxSnapshotRecvBytesPerSecond),
			// NotifyCommit:                  viper.GetBool(constant.NotifyCommit),

			// SystemTickerPrecision: viper.GetDuration(constant.SystemTickerPrecision),

			// LogDB:               config.GetTinyMemLogDBConfig(),
			LogDBFactory:        variable.DefaultLogDbFactory,
			RaftRPCFactory:      variable.DefaultRaftRPCFactory,
			RaftEventListener:   variable.DefaultRaftEventListener,
			SystemEventListener: variable.DefaultSystemEventListener,
		},
	}
}

func startCluster(f *flamed.Flamed) {
	clusterID := uint64(1)
	clusterName := "cluster-1"

	// im := getInitialMembers(strings.Split(viper.GetString(constant.InitialMembers), ";"))

	// if len(im) == 0 {
	// 	if !viper.GetBool(constant.Join) {
	// 		im[viper.GetUint64(constant.NodeID)] = viper.GetString(constant.RaftAddress)
	// 	}
	// }

	clusterStoragePath := path.Join(storagePath, clusterName)

	storagedConfiguration := &conf.StoragedConfiguration{
		StoragedConfigurationInput: conf.StoragedConfigurationInput{
			AutoIndexMeta:         true,
			IndexEnable:           true,
			StateStoragePath:      clusterStoragePath + "/state",
			StateStorageSecretKey: nil,
			IndexStoragePath:      clusterStoragePath + "/index",
			IndexStorageSecretKey: nil,

			AutoBuildIndex: true,

			// ProposalReceiver: GetApp().GetProposalReceiver(),
		},
		// TransactionProcessorMap: GetApp().GetTPMap(),
	}

	clusterConfiguration := conf.SimpleOnDiskClusterConfiguration(
		clusterID,
		clusterName,
		nil,
		true)

	raftConfiguration := getRaftConfiguration()

	err := f.StartOnDiskCluster(
		clusterConfiguration,
		storagedConfiguration,
		raftConfiguration)
	utility2.GetServerStatus().SetRAFTServer(true)
	if err != nil {
		utility2.GetServerStatus().SetRAFTServer(false)
		panic(err)
	}
}

func getRaftConfiguration() *conf.RaftConfiguration {
	return &conf.RaftConfiguration{
		RaftConfigurationInput: conf.RaftConfigurationInput{
			// NodeID:                 viper.GetUint64(constant.NodeID),
			// CheckQuorum:            viper.GetBool(constant.CheckQuorum),
			// ElectionRTT:            viper.GetUint64(constant.ElectionRTT),
			// HeartbeatRTT:           viper.GetUint64(constant.HeartbeatRTT),
			// SnapshotEntries:        viper.GetUint64(constant.SnapshotEntries),
			// CompactionOverhead:     viper.GetUint64(constant.CompactionOverhead),
			// OrderedConfigChange:    viper.GetBool(constant.OrderedConfigChange),
			// MaxInMemLogSize:        viper.GetUint64(constant.MaxInMemLogSize),
			// DisableAutoCompactions: viper.GetBool(constant.DisableAutoCompactions),
			// IsObserver:             viper.GetBool(constant.IsObserver),
			// IsWitness:              viper.GetBool(constant.IsWitness),
			// Quiesce:                viper.GetBool(constant.Quiesce),
		},
	}
}
