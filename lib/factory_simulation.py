import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
from dataclasses import dataclass
from typing import List, Dict, Tuple
import random
from collections import deque
import seaborn as sns

@dataclass
class PolicyType:
    name: str
    revenue: float
    inter_arrival_time: float
    inter_arrival_std: float

@dataclass
class Workstation:
    id: int
    processing_times: Dict[str, Dict[str, float]]  # policy_type -> {time, std_dev}
    queue: deque
    current_job: str = None
    completion_time: float = 0.0
    total_processed: int = 0
    total_idle_time: float = 0.0

class FactorySimulation:
    def __init__(self):
        # Policy types with their characteristics
        self.policy_types = {
            'RUN': PolicyType('Request for Underwriting', 50.0, 9.0, 1.0),
            'RERUN': PolicyType('Request for Renewal', 30.0, 9.0, 1.0),
            'RAP': PolicyType('Request for Additional Price', 42.0, 9.0, 1.0)
        }
        
        # Workstations with processing times (time, std_dev)
        self.workstations = {
            1: Workstation(1, {
                'RUN': {'time': 7.0, 'std_dev': 5.0},
                'RERUN': {'time': 7.8, 'std_dev': 0.2},
                'RAP': {'time': 7.4, 'std_dev': 2.5}
            }, deque()),
            2: Workstation(2, {
                'RUN': {'time': 8.7, 'std_dev': 5.0},
                'RERUN': {'time': 7.1, 'std_dev': 0.2},
                'RAP': {'time': 9.4, 'std_dev': 2.5}
            }, deque()),
            3: Workstation(3, {
                'RUN': {'time': 9.4, 'std_dev': 5.0},
                'RERUN': {'time': 9.5, 'std_dev': 0.2},
                'RAP': {'time': 7.8, 'std_dev': 2.5}
            }, deque()),
            4: Workstation(4, {
                'RUN': {'time': 8.1, 'std_dev': 5.0},
                'RERUN': {'time': 8.8, 'std_dev': 0.2},
                'RAP': {'time': 8.6, 'std_dev': 2.5}
            }, deque())
        }
        
        self.simulation_time = 0.0
        self.completed_jobs = []
        self.job_id_counter = 0
        
    def generate_inter_arrival_time(self, policy_type: str) -> float:
        """Generate inter-arrival time for a policy type"""
        policy = self.policy_types[policy_type]
        return max(0.1, np.random.normal(policy.inter_arrival_time, policy.inter_arrival_std))
    
    def generate_processing_time(self, workstation_id: int, policy_type: str) -> float:
        """Generate processing time for a job at a specific workstation"""
        ws = self.workstations[workstation_id]
        time_params = ws.processing_times[policy_type]
        return max(0.1, np.random.normal(time_params['time'], time_params['std_dev']))
    
    def create_job(self, policy_type: str) -> Dict:
        """Create a new job"""
        self.job_id_counter += 1
        return {
            'id': self.job_id_counter,
            'type': policy_type,
            'arrival_time': self.simulation_time,
            'start_times': {},
            'completion_times': {},
            'revenue': self.policy_types[policy_type].revenue
        }
    
    def simulate_workstation(self, ws_id: int, current_time: float):
        """Simulate a single workstation"""
        ws = self.workstations[ws_id]
        
        # Check if current job is completed
        if ws.current_job and current_time >= ws.completion_time:
            # Job completed, move to next workstation or finish
            job = ws.current_job
            job['completion_times'][ws_id] = ws.completion_time
            
            if ws_id < 4:  # Move to next workstation
                self.workstations[ws_id + 1].queue.append(job)
            else:  # Job completed
                job['total_completion_time'] = ws.completion_time
                self.completed_jobs.append(job)
            
            ws.current_job = None
            ws.total_processed += 1
        
        # Start new job if workstation is idle and queue has jobs
        if not ws.current_job and ws.queue:
            job = ws.queue.popleft()
            job['start_times'][ws_id] = current_time
            
            processing_time = self.generate_processing_time(ws_id, job['type'])
            ws.completion_time = current_time + processing_time
            ws.current_job = job
    
    def run_simulation(self, duration: float, policy_mix: Dict[str, float] = None):
        """Run the simulation for specified duration"""
        if policy_mix is None:
            policy_mix = {'RUN': 0.4, 'RERUN': 0.3, 'RAP': 0.3}  # Default mix
        
        # Reset simulation
        self.simulation_time = 0.0
        self.completed_jobs = []
        self.job_id_counter = 0
        
        for ws in self.workstations.values():
            ws.queue.clear()
            ws.current_job = None
            ws.completion_time = 0.0
            ws.total_processed = 0
            ws.total_idle_time = 0.0
        
        # Generate arrival times
        next_arrivals = {}
        for policy_type in policy_mix:
            next_arrivals[policy_type] = self.generate_inter_arrival_time(policy_type)
        
        # Main simulation loop
        while self.simulation_time < duration:
            # Find next event
            next_event_time = min(next_arrivals.values())
            
            # Check workstation completions
            for ws in self.workstations.values():
                if ws.current_job and ws.completion_time < next_event_time:
                    next_event_time = ws.completion_time
            
            # Advance time to next event
            self.simulation_time = next_event_time
            
            # Process arrivals
            for policy_type, next_arrival in next_arrivals.items():
                if next_arrival <= self.simulation_time:
                    # Create new job
                    job = self.create_job(policy_type)
                    self.workstations[1].queue.append(job)
                    
                    # Schedule next arrival
                    next_arrivals[policy_type] = self.simulation_time + self.generate_inter_arrival_time(policy_type)
            
            # Process all workstations
            for ws_id in range(1, 5):
                self.simulate_workstation(ws_id, self.simulation_time)
    
    def calculate_metrics(self) -> Dict:
        """Calculate performance metrics"""
        if not self.completed_jobs:
            return {}
        
        total_revenue = sum(job['revenue'] for job in self.completed_jobs)
        total_jobs = len(self.completed_jobs)
        
        # Calculate throughput
        throughput = total_jobs / self.simulation_time if self.simulation_time > 0 else 0
        
        # Calculate average cycle time
        cycle_times = [job['total_completion_time'] - job['arrival_time'] for job in self.completed_jobs]
        avg_cycle_time = np.mean(cycle_times) if cycle_times else 0
        
        # Calculate workstation utilization
        utilizations = {}
        for ws_id, ws in self.workstations.items():
            busy_time = sum(job['completion_times'].get(ws_id, 0) - job['start_times'].get(ws_id, 0) 
                          for job in self.completed_jobs if ws_id in job['start_times'])
            utilizations[ws_id] = busy_time / self.simulation_time if self.simulation_time > 0 else 0
        
        # Queue lengths
        queue_lengths = {ws_id: len(ws.queue) for ws_id, ws in self.workstations.items()}
        
        return {
            'total_revenue': total_revenue,
            'total_jobs': total_jobs,
            'throughput': throughput,
            'avg_cycle_time': avg_cycle_time,
            'utilizations': utilizations,
            'queue_lengths': queue_lengths,
            'simulation_time': self.simulation_time
        }
    
    def optimize_product_mix(self, duration: float = 1000.0, num_trials: int = 100) -> Dict:
        """Find optimal product mix to maximize revenue"""
        best_mix = None
        best_revenue = 0
        results = []
        
        for trial in range(num_trials):
            # Generate random policy mix
            mix = np.random.dirichlet([1, 1, 1])  # Random proportions
            policy_mix = {
                'RUN': mix[0],
                'RERUN': mix[1], 
                'RAP': mix[2]
            }
            
            # Run simulation
            self.run_simulation(duration, policy_mix)
            metrics = self.calculate_metrics()
            
            if metrics and metrics['total_revenue'] > best_revenue:
                best_revenue = metrics['total_revenue']
                best_mix = policy_mix.copy()
            
            results.append({
                'mix': policy_mix.copy(),
                'revenue': metrics.get('total_revenue', 0),
                'throughput': metrics.get('throughput', 0)
            })
        
        return {
            'best_mix': best_mix,
            'best_revenue': best_revenue,
            'all_results': results
        }

def visualize_results(simulation: FactorySimulation, optimization_results: Dict):
    """Create visualizations of simulation results"""
    fig, axes = plt.subplots(2, 2, figsize=(15, 12))
    
    # 1. Workstation Utilization
    metrics = simulation.calculate_metrics()
    if metrics:
        ws_ids = list(metrics['utilizations'].keys())
        utilizations = list(metrics['utilizations'].values())
        
        axes[0, 0].bar(ws_ids, utilizations, color=['#FF6B6B', '#4ECDC4', '#45B7D1', '#96CEB4'])
        axes[0, 0].set_title('Workstation Utilization')
        axes[0, 0].set_xlabel('Workstation ID')
        axes[0, 0].set_ylabel('Utilization Rate')
        axes[0, 0].set_ylim(0, 1)
        
        # Add value labels on bars
        for i, v in enumerate(utilizations):
            axes[0, 0].text(ws_ids[i], v + 0.01, f'{v:.2f}', ha='center')
    
    # 2. Queue Lengths
    if metrics:
        queue_lengths = list(metrics['queue_lengths'].values())
        axes[0, 1].bar(ws_ids, queue_lengths, color=['#FF6B6B', '#4ECDC4', '#45B7D1', '#96CEB4'])
        axes[0, 1].set_title('Current Queue Lengths')
        axes[0, 1].set_xlabel('Workstation ID')
        axes[0, 1].set_ylabel('Queue Length')
        
        # Add value labels on bars
        for i, v in enumerate(queue_lengths):
            axes[0, 1].text(ws_ids[i], v + 0.1, f'{v}', ha='center')
    
    # 3. Revenue vs Policy Mix
    results = optimization_results['all_results']
    run_props = [r['mix']['RUN'] for r in results]
    revenues = [r['revenue'] for r in results]
    
    scatter = axes[1, 0].scatter(run_props, revenues, c=revenues, cmap='viridis', alpha=0.6)
    axes[1, 0].set_title('Revenue vs RUN Policy Proportion')
    axes[1, 0].set_xlabel('RUN Policy Proportion')
    axes[1, 0].set_ylabel('Total Revenue')
    plt.colorbar(scatter, ax=axes[1, 0], label='Revenue')
    
    # 4. Best Policy Mix
    best_mix = optimization_results['best_mix']
    if best_mix:
        policy_names = list(best_mix.keys())
        proportions = list(best_mix.values())
        
        colors = ['#FF6B6B', '#4ECDC4', '#45B7D1']
        wedges, texts, autotexts = axes[1, 1].pie(proportions, labels=policy_names, autopct='%1.1f%%', 
                                                  colors=colors, startangle=90)
        axes[1, 1].set_title(f'Optimal Policy Mix\n(Revenue: ${optimization_results["best_revenue"]:.2f})')
    
    plt.tight_layout()
    plt.show()

def main():
    """Main simulation function"""
    print("🏭 Factory Simulation - Scenario 4")
    print("=" * 50)
    
    # Create simulation
    sim = FactorySimulation()
    
    # Run initial simulation with default mix
    print("Running simulation with default policy mix...")
    sim.run_simulation(duration=1000.0)
    metrics = sim.calculate_metrics()
    
    if metrics:
        print(f"\n📊 Simulation Results:")
        print(f"Total Revenue: ${metrics['total_revenue']:.2f}")
        print(f"Total Jobs Processed: {metrics['total_jobs']}")
        print(f"Throughput: {metrics['throughput']:.2f} jobs/hour")
        print(f"Average Cycle Time: {metrics['avg_cycle_time']:.2f} minutes")
        
        print(f"\n🔧 Workstation Utilization:")
        for ws_id, util in metrics['utilizations'].items():
            print(f"  Workstation {ws_id}: {util:.2%}")
        
        print(f"\n📋 Current Queue Lengths:")
        for ws_id, length in metrics['queue_lengths'].items():
            print(f"  Workstation {ws_id}: {length} jobs")
    
    # Optimize product mix
    print(f"\n🔍 Optimizing product mix for maximum revenue...")
    optimization_results = sim.optimize_product_mix(duration=1000.0, num_trials=200)
    
    if optimization_results['best_mix']:
        print(f"\n🎯 Optimal Policy Mix:")
        for policy, proportion in optimization_results['best_mix'].items():
            print(f"  {policy}: {proportion:.1%}")
        print(f"Expected Revenue: ${optimization_results['best_revenue']:.2f}")
    
    # Create visualizations
    print(f"\n📈 Generating visualizations...")
    visualize_results(sim, optimization_results)
    
    # Run simulation with optimal mix
    print(f"\n🚀 Running simulation with optimal policy mix...")
    sim.run_simulation(duration=1000.0, policy_mix=optimization_results['best_mix'])
    optimal_metrics = sim.calculate_metrics()
    
    if optimal_metrics:
        print(f"\n📊 Optimal Mix Results:")
        print(f"Total Revenue: ${optimal_metrics['total_revenue']:.2f}")
        print(f"Total Jobs Processed: {optimal_metrics['total_jobs']}")
        print(f"Throughput: {optimal_metrics['throughput']:.2f} jobs/hour")
        print(f"Average Cycle Time: {optimal_metrics['avg_cycle_time']:.2f} minutes")
        
        improvement = ((optimal_metrics['total_revenue'] - metrics['total_revenue']) / 
                      metrics['total_revenue'] * 100) if metrics['total_revenue'] > 0 else 0
        print(f"Revenue Improvement: {improvement:.1f}%")

if __name__ == "__main__":
    main()
