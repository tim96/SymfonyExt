
namespace Symfony\Component\Stopwatch;

class StopwatchPeriod
{
    protected start;
    protected end;
    protected memory;

    /**
     * Constructor.
     *
     * @param int $start The relative time of the start of the period (in milliseconds)
     * @param int $end   The relative time of the end of the period (in milliseconds)
     */
    public function __construct(int start, int end) -> void
    {
        let this->start =  (int) start;
        let this->end =  (int) end;
        let this->memory =  memory_get_usage(true);
    }
    
    /**
     * Gets the relative time of the start of the period.
     *
     * @return int The time (in milliseconds)
     */
    public function getStartTime() -> int
    {
        return this->start;
    }
    
    /**
     * Gets the relative time of the end of the period.
     *
     * @return int The time (in milliseconds)
     */
    public function getEndTime() -> int
    {
        return this->end;
    }
    
    /**
     * Gets the time spent in this period.
     *
     * @return int The period duration (in milliseconds)
     */
    public function getDuration() -> int
    {
        return this->end - this->start;
    }
    
    /**
     * Gets the memory usage.
     *
     * @return int The memory usage (in bytes)
     */
    public function getMemory() -> int
    {
        return this->memory;
    }

}