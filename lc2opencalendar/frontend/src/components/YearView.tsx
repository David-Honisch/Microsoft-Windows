import MiniMonth from './MiniMonth';
import * as T from '../time';

export default function YearView({
  cursor,
  today,
  onDayClick,
}: {
  cursor: number;
  today: number;
  onDayClick: (day: number) => void;
}) {
  const year = T.ymd(cursor)[0];
  return (
    <div className="yv">
      <div className="yv-grid">
        {T.MONTHS.map((name, m) => (
          <MiniMonth key={name} month={T.makeDay(year, m, 1)} today={today} onPick={onDayClick} variant="year" />
        ))}
      </div>
    </div>
  );
}
