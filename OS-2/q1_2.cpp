#include <iostream>
#include <iomanip>
#include <fstream>
#include <vector>
#include <algorithm>

#define DRAW_LINE std::cout << std::string(60, '*') << std::endl;

class Job {
public:
    int id, priority, arrival, bustCount, bustSum, remaining, entry, reentry, end;
    std::vector<int> cpuBust, ioBust;

    Job() : id(0), priority(0), arrival(0), bustCount(0), bustSum(0), remaining(0), entry(0), reentry(0), end(0) {
        cpuBust.resize(101);
        ioBust.resize(100);
    }

    void readFromFile(std::ifstream &file);
    void display() const;
    int getTurnaround() const { return end - entry; }
};

void Job::readFromFile(std::ifstream &file) {
    file >> id >> priority >> arrival;
    reentry = arrival;

    int temp, t = 0, sum = 0;
    while (file >> temp && temp != -1) {
        sum += temp;
        if (t % 2 == 0) cpuBust[t / 2] = temp;
        else ioBust[(t - 1) / 2] = temp;
        ++t;
    }
    bustSum = sum;
    bustCount = t;
    remaining = sum;
}

void Job::display() const {
    std::cout << id << "\t" << priority << "\t" << arrival << "\t";
    for (int i = 0; i < bustCount; ++i) {
        if (i % 2 == 0) std::cout << cpuBust[i / 2] << " ";
        else std::cout << ioBust[(i - 1) / 2] << " ";
    }
    std::cout << std::endl;
}

class Scheduler {
public:
    std::vector<Job> jobs;
    explicit Scheduler(const std::string &filename);

    void sortJobs(int parameter);
    void displayJobs();
    void simulateFCFS();
    void simulatePriority();
    void simulateRoundRobin(int quantum);

private:
    void displayGanttChart(const std::string &chart);
    void displaySummary(const std::vector<Job> &pipeline, long long timer);
    static bool compareArrival(const Job &a, const Job &b) { return a.arrival < b.arrival; }
    static bool comparePriority(const Job &a, const Job &b) { return a.priority < b.priority; }
    static bool compareEnd(const Job &a, const Job &b) { return a.end < b.end; }
};

Scheduler::Scheduler(const std::string &filename) {
    std::ifstream jobsFile(filename);
    if (!jobsFile.is_open()) {
        std::cerr << "Error opening file." << std::endl;
        exit(EXIT_FAILURE);
    }
    for (int i = 0; i < 20 && !jobsFile.eof(); ++i) {
        Job job;
        job.readFromFile(jobsFile);
        jobs.push_back(job);
    }
}

void Scheduler::sortJobs(int parameter) {
    switch (parameter) {
        case 0: std::sort(jobs.begin(), jobs.end(), compareArrival); break;
        case 1: std::sort(jobs.begin(), jobs.end(), comparePriority); break;
        case 3: std::sort(jobs.begin(), jobs.end(), compareEnd); break;
        default: break;
    }
}

void Scheduler::displayJobs() {
    std::cout << "\nJOBID\tPrior\tArrival\t\tBust Time\n";
    for (const auto &job : jobs) job.display();
}

void Scheduler::simulateFCFS() {
    sortJobs(0);
    std::vector<Job> pipeline;
    long long timer = 0;
    int jobRemainingCount = jobs.size();
    std::string ganttChart;

    for (auto &job : jobs) {
        if (job.arrival <= timer) {
            ganttChart += "P" + std::to_string(job.id) + " ";
            job.entry = timer;
            job.end = timer + job.bustSum;
            pipeline.push_back(job);
            timer = job.end;
            --jobRemainingCount;
        } else {
            ++timer;
        }
    }

    displayGanttChart(ganttChart);
    displaySummary(pipeline, timer);
}

void Scheduler::simulatePriority() {
    sortJobs(1);
    std::vector<Job> pipeline;
    long long timer = 0;
    int jobRemainingCount = jobs.size();
    std::string ganttChart;
    std::vector<bool> jobCompleted(jobs.size(), false);

    while (jobRemainingCount > 0) {
        int minPriorityIdx = -1;
        int minPriority = std::numeric_limits<int>::max();

        for (int i = 0; i < jobs.size(); ++i) {
            if (jobs[i].arrival <= timer && jobs[i].priority < minPriority && !jobCompleted[i]) {
                minPriorityIdx = i;
                minPriority = jobs[i].priority;
            }
        }

        if (minPriorityIdx != -1) {
            Job &job = jobs[minPriorityIdx];
            ganttChart += "P" + std::to_string(job.id) + " ";
            job.entry = timer;
            job.end = timer + job.bustSum;
            pipeline.push_back(job);
            jobCompleted[minPriorityIdx] = true;
            timer = job.end;
            --jobRemainingCount;
        } else {
            ++timer;
        }
    }

    displayGanttChart(ganttChart);
    displaySummary(pipeline, timer);
}

void Scheduler::simulateRoundRobin(int quantum) {
    sortJobs(0);
    std::string ganttChart;
    long long timer = 0;
    std::vector<int> jobBustStatus(jobs.size(), 0), jobStart(jobs.size(), 0);
    int jobCount = 0;

    while (jobCount < jobs.size()) {
        for (auto &job : jobs) {
            if (job.reentry <= timer && jobBustStatus[job.id] != -1) {
                if (jobStart[job.id] == 0) job.entry = timer;

                int chunk = job.cpuBust[jobBustStatus[job.id]];
                ganttChart += "P" + std::to_string(job.id);

                if (chunk > quantum) {
                    job.cpuBust[jobBustStatus[job.id]] -= quantum;
                    job.remaining -= quantum;
                    timer += quantum;
                } else {
                    timer += chunk;
                    job.reentry = timer + job.ioBust[jobBustStatus[job.id]];
                    if (++jobBustStatus[job.id] == job.bustCount) {
                        job.end = job.reentry;
                        jobBustStatus[job.id] = -1;
                        ganttChart += "*";
                        ++jobCount;
                    }
                }
                ganttChart += " ";
            }
        }
        timer++;
    }

    displayGanttChart(ganttChart);
    displaySummary(jobs, timer);
}

void Scheduler::displayGanttChart(const std::string &chart) {
    std::cout << "Gantt Chart: " << chart << std::endl;
}

void Scheduler::displaySummary(const std::vector<Job> &pipeline, long long timer) {
    int waitTime = 0;
    std::cout << "JOBID\tArrival\tEntry\tExit\tTurnaround\n";
    for (const auto &job : pipeline) {
        std::cout << job.id << "\t" << job.arrival << "\t" << job.entry << "\t" << job.end << "\t" << job.getTurnaround() << "\n";
        waitTime += job.entry - job.arrival;
    }
    std::cout << "\nTotal Time: " << timer << " units\n";
    std::cout << "Average Waiting Time: " << static_cast<float>(waitTime) / pipeline.size() << " units\n";
}

int main(int argc, char *argv[]) {
    if (argc != 2) {
        std::cerr << "Usage: " << argv[0] << " <jobs_file>" << std::endl;
        return EXIT_FAILURE;
    }

    Scheduler scheduler(argv[1]);
    std::cout << "\nOS Scheduling Simulation\n\nJob Sheet";
    scheduler.displayJobs();

    std::cout << "\nFirst Come First Serve\n\n";
    scheduler.simulateFCFS();
    DRAW_LINE

    std::cout << "\nNon Preemptive Priority\n\n";
    scheduler.simulatePriority();
    DRAW_LINE

    std::cout << "\nRound Robin\n\n";
    scheduler.simulateRoundRobin(20);
    DRAW_LINE

    return 0;
}
