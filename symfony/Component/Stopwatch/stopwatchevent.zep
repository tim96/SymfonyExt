
namespace Symfony\Component\Stopwatch;

class StopwatchEvent
{
    /**
     * @var StopwatchPeriod[]
     */
    protected periods = [];
    /**
     * @var float
     */
    protected origin;
    /**
     * @var string
     */
    protected category;
    /**
     * @var float[]
     */
    protected started = [];
    /**
     * Constructor.
     *
     * @param float       $origin   The origin time in milliseconds
     * @param string|null $category The event category or null to use the default
     *
     * @throws \InvalidArgumentException When the raw time is not valid
     */
    public function __construct(float origin, category = null) -> void
    {
        let this->origin =  this->formatTime(origin);
        let this->category =  is_string(category) ? category  : "default";
    }
    
    /**
     * Gets the category.
     *
     * @return string The category
     */
    public function getCategory() -> string
    {
        return this->category;
    }
    
    /**
     * Gets the origin.
     *
     * @return float The origin in milliseconds
     */
    public function getOrigin() -> float
    {
        return this->origin;
    }
    
    /**
     * Starts a new event period.
     *
     * @return StopwatchEvent The event
     */
    public function start() -> <StopwatchEvent>
    {
        let this->started[] =  this->getNow();
        return this;
    }
    
    /**
     * Stops the last started event period.
     *
     * @throws \LogicException When start wasn't called before stopping
     *
     * @return StopwatchEvent The event
     *
     * @throws \LogicException When stop() is called without a matching call to start()
     */
    public function stop() -> <StopwatchEvent>
    {
        if !(count(this->started)) {
            throw new \LogicException("stop() called but start() has not been called before.");
        }
        let this->periods[] = new StopwatchPeriod(array_pop(this->started), this->getNow());
        return this;
    }
    
    /**
     * Checks if the event was started.
     *
     * @return bool
     */
    public function isStarted() -> bool
    {
        return !(empty(this->started));
    }
    
    /**
     * Stops the current period and then starts a new one.
     *
     * @return StopwatchEvent The event
     */
    public function lap() -> <StopwatchEvent>
    {
        return this->stop()->start();
    }
    
    /**
     * Stops all non already stopped periods.
     */
    public function ensureStopped() -> void
    {
        while (count(this->started)) {
            this->stop();
        }
    }
    
    /**
     * Gets all event periods.
     *
     * @return StopwatchPeriod[] An array of StopwatchPeriod instances
     */
    public function getPeriods() -> array
    {
        return this->periods;
    }
    
    /**
     * Gets the relative time of the start of the first period.
     *
     * @return int The time (in milliseconds)
     */
    public function getStartTime() -> int
    {
        return  isset this->periods[0] ? this->periods[0]->getStartTime()  : 0;
    }
    
    /**
     * Gets the relative time of the end of the last period.
     *
     * @return int The time (in milliseconds)
     */
    public function getEndTime() -> int
    {
        var count;
    
        let count =  count(this->periods);
        return  count ? this->periods[count - 1]->getEndTime()  : 0;
    }
    
    /**
     * Gets the duration of the events (including all periods).
     *
     * @return int The duration (in milliseconds)
     */
    public function getDuration() -> int
    {
        var periods, stopped, left, i, index, total, period;
    
        let periods =  this->periods;
        let stopped =  count(periods);
        let left =  count(this->started) - stopped;
        let i = 0;
        for i in range(0, left) {
            let index =  stopped + i;
            let periods[] = new StopwatchPeriod(this->started[index], this->getNow());
        }
        let total = 0;
        for period in periods {
            let total += period->getDuration();
        }
        return total;
    }
    
    /**
     * Gets the max memory usage of all periods.
     *
     * @return int The memory usage (in bytes)
     */
    public function getMemory() -> int
    {
        var memory, period;
    
        let memory = 0;
        for period in this->periods {
            if period->getMemory() > memory {
                let memory =  period->getMemory();
            }
        }
        return memory;
    }
    
    /**
     * Return the current time relative to origin.
     *
     * @return float Time in ms
     */
    protected function getNow() -> float
    {
        return this->formatTime(microtime(true) * 1000 - this->origin);
    }
    
    /**
     * Formats a time.
     *
     * @param int|float $time A raw time
     *
     * @return float The formatted time
     *
     * @throws \InvalidArgumentException When the raw time is not valid
     */
    protected function formatTime(time) -> float
    {
        if !(is_numeric(time)) {
            throw new \InvalidArgumentException("The time must be a numerical value");
        }
        return round(time, 1);
    }
    
    /**
     * @return string
     */
    public function __toString() -> string
    {
        return sprintf("%s: %.2F MiB - %d ms", this->getCategory(), this->getMemory() / 1024 / 1024, this->getDuration());
    }

}